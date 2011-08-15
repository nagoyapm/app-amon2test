package Nagoyapm::Amon2Test::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;
use Nagoyapm::Amon2Test::Util qw/new_oauth_consumer new_oid/;
use Time::Piece;
use JSON;
use Encode;
use Data::Dumper;

get '/' => sub {
    my ($c) = @_;
    my ($req, $db) = ($c->req, $c->db);
    my $vars = +{};


    my $itr_line = $db->line->find->sort({ created_at => -1, id => -1 })->limit(20);


    my $user = +{};
    if ( defined ( my $access_token = $c->session->get('access_token') ) ) {
        $user = $db->user->find_one({ token => $access_token->token });
    };



    $vars = +{
        user  => $user,
        lines => $itr_line,
    };

    $c->render('index.tx', $vars);
};

post '/' => sub {
    my ($c) = @_;
    my ($req, $db) = ($c->req, $c->db);

    my $id_ins;
    my $o = $db->line->query({}, { id => 0 })->sort({ id => -1 })->limit(1)->next;
    $id_ins = ( $o->{id} || 0 ) + 1;


    my $code = $req->param('code');

    my $data = +{
        id         => $id_ins,
        code       => $code,
        created_at => localtime->epoch,
    };

    my $ins = $db->line->insert($data);

    $c->redirect('/');
    #$c->render('index.tx');
};


get '/line/{id}' => sub {
    my ($c, $args) = @_;
    my ($req, $db) = ($c->req, $c->db);

    my $line_id = $args->{id};
    my $data;

    my $oid = new_oid($line_id);

    $data = $db->line->find_one({ _id => $oid });


    my $vars = +{
        uri  => $req->uri,
        data => $data,
    };


    $c->render('line/show.tx', $vars);
};


get '/test/lleval' => sub {
    my ($c) = @_;
    $c->render('test/lleval.tx');
};




any '/oauth/login/{type}' => sub {
    my ($c, $args) = @_;
    my ($req, $db, $session) = ($c->req, $c->db, $c->session);

    my $auth_type = $args->{type};

    # should be loaded from config
    my $oauth_conf = $c->config->{'OAuth'};
    my $oauth_consumer;
    my $request_token;

    unless ( defined $oauth_conf ) {
    }

    $oauth_consumer = new_oauth_consumer($oauth_conf, $auth_type);

    # twitter
    if ( $auth_type eq 'twitter' ) {
        $request_token = $oauth_consumer->get_request_token(
            callback_url => $oauth_conf->{twitter}{callback_url},
        );
    }
    #
    else {
        return $c->render('oauth/login.tx', {
            invalid_auth_type => 1,
        });
    }

    $session->set( request_token => $request_token );
    $session->set( auth_type => $auth_type );

    return $c->redirect(
        $oauth_consumer->url_to_authorize( token => $request_token ),
    );
};


get '/oauth/callback' => sub {
    my ($c) = @_;
    my ($req, $db, $session) = ($c->req, $c->db, $c->session);
    my $vars = +{};

    # cancelled
    if ( defined $req->param('denied') ) {
        $vars->{denied} = $req->param('denied');
    }
    # authorized
    else {
        my $verifier      = $req->param('oauth_verifier');
        my $request_token = $session->get('request_token');
        my $auth_type     = $session->get('auth_type');

        my $oauth_conf = $c->config->{'OAuth'};
        my $oauth_consumer = new_oauth_consumer($oauth_conf, $auth_type);

        # if (0) {
        #     die 'auth_type is not defined!';
        # }

        my $access_token = $oauth_consumer->get_access_token(
            token    => $request_token,
            verifier => $verifier,
        );

        my $ss_access_token = $session->get('access_token') || +{};
        $ss_access_token->{$auth_type} = $access_token;

        $session->set( access_token => $ss_access_token );
        $session->remove('request_token');
        $session->remove('auth_type');


        # （存在していなければ）ユーザ情報を登録する
        # twitter
        if ( $auth_type eq 'twitter' ) {
            my $res = $oauth_consumer->request(
                method => 'GET',
                url    => 'http://api.twitter.com/1/account/verify_credentials.json',
                token  => $access_token,
                params => {
                    include_entities => 0,
                    skip_status      => 1,
                },
            );

            # 200
            if ( $res->code eq '200' ) {
                my $user = decode_json( $res->decoded_content );
                my $user_id = int( $user->{id} );

                my $up = $db->user->update(
                    {
                        id           => $user_id,
                        service_name => 'twitter'
                    },
                    {
                        service_name => 'twitter',
                        id           => $user_id,
                        username     => $user->{screen_name},
                        token        => $access_token->token,
                    },
                    { upsert => 1 },
                );
            }
            # non-200
            else {
            }
        }
    }


    $c->redirect( $req->base );
    #$c->render('oauth/callback.tx', $vars);
};



get '/logout' => sub {
    my ($c) = @_;
    my ($req, $db, $ss) = ($c->req, $c->db, $c->session);

    my $access_token = $ss->get('access_token');

    $db->user->update(
        { token => $access_token->token },
        { token => '' },
    );

    $c->redirect( $req->base );
};



1;
