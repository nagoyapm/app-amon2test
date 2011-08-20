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
use Data::Validator;
use Mouse::Util::TypeConstraints;

get '/' => sub {
    my ($c) = @_;
    return render_top($c);
};


post '/' => sub {
    my ($c) = @_;
    my ($req, $db, $ss) = ($c->req, $c->db, $c->session);

    my $access_token = $ss->get('access_token');

    my $username     = $req->param('username');
    my $lang         = $req->param('lang')  ||  'perl5';
    my $line         = $req->param('line');
    my $comment      = $req->param('comment');
    my $enable_tweet = $req->param('enable_tweet') || 0;


    #
    my ($my, $my_oid);
    if ( defined $access_token ) {
        $my = $db->user->find_one({ token => $access_token->token });
    };

    if ( defined $my ) {
        $my_oid = $my->{_id};
    }
    else {
        $my = {
            service_name => '',
            username     => $username,
        };

        $my_oid = $db->user->insert({
            username => $username,
        });
    }


    # validation
    my $params = $c->req->parameters;
    unless (is_valid($params)) {
        my $err = 'invalidated';
        $c->fillin_form($c->req);
        return render_top($c, {err => $err});
    }



    #
    my $line_data = +{
        user       => $my_oid,
        lang       => $lang,
        line       => $line,
        comment    => $comment,
        created_at => localtime->epoch,
    };

    my $line_oid = $db->line->insert($line_data);


    if ( $enable_tweet  &&  $my->{service_name} eq 'twitter' ) {
        my $base_message = encode_utf8(
            $comment ne '' ? $comment : 'new line!'
        );

        my $line_url = sprintf '%s/line/%s', $req->base, $line_oid;

        my $hashtags = join ' ', map {
            '#' . $_;
        } qw/ oscnagoya nagoyapm /;

        my $status_text = "${base_message} ${line_url} ${hashtags}";

        my $oauth_consumer = new_oauth_consumer($c->config->{'OAuth'}, 'twitter');
        my $res = $oauth_consumer->request(
            method => 'POST',
            url    => 'http://api.twitter.com/1/statuses/update.json',
            token  => $access_token,
            params => {
                status => $status_text,
            },
        );

        # 200
        if ( $res->code eq '200' ) {
        }
        # non-200
        else {
        }
    }


    $c->redirect('/');
    #$c->render('index.tx');
};


get '/line/{id}' => sub {
    my ($c, $args) = @_;
    my ($req, $db) = ($c->req, $c->db);

    #
    my $my;
    if ( defined ( my $access_token = $c->session->get('access_token') ) ) {
        $my = $db->user->find_one({ token => $access_token->token });
    };

    #
    my $line_id = $args->{id};
    my ($line_data, $user_data);
    my $line_oid = new_oid( $args->{id} );
    $line_data = $db->line->find_one({ _id => $line_oid });
    $user_data = $db->user->find_one({ _id => $line_data->{user} });


    my $vars = +{
        my        => $my,
        line_data => $line_data,
        user_data => $user_data,
        uri       => $req->uri,
    };


    $c->render('line/show.tx', $vars);
};


get '/user/{id}' => sub {
    my ($c, $args) = @_;
    my ($req, $db, $ss) = ($c->req, $c->db, $c->session);

    #
    my $my;
    if ( defined ( my $access_token = $ss->get('access_token') ) ) {
        $my = $db->user->find_one({ token => $access_token->token });
    };

    my $user_oid = new_oid( $args->{id} );

    my $user = $db->user->find_one({ _id => $user_oid});
    unless ( defined $user ) {
    }

    my $itr_line = $db->line->find({ user => $user_oid })->sort({ created_at => -1 });


    my $vars = {
        my    => $my,
        user  => $user,
        lines => $itr_line,
    };

    $c->render('user/show.tx', $vars);
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
            callback_url => $req->base . $oauth_conf->{twitter}{callback_url},
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

        $session->set( access_token => $access_token );
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

    if ( defined $access_token ) {
        $db->user->update(
            { token => $access_token->token },
            { '$set' => { token => '' } },
        );

        $ss->remove('access_token');
    }

    $c->redirect( $req->base );
};




subtype 'NotNullStr', as 'Str', where { not($_ eq q()) }, message { "This form not allowed empty" };

sub is_valid {
    my ($params) = @_;

    my $v = Data::Validator->new(
        username => {isa => 'NotNullStr'},
        line     => {isa => 'NotNullStr'},
    )->with('AllowExtra');
    eval {
        my ($new_params, $extra) = $v->validate(%$params);
    };
    if ($@) {
        # error
        return 0;
    }
    return 1;
}

sub render_top {
    my ($c, $params) = @_;
    my ($req, $db) = ($c->req, $c->db);
    my $vars = +{};

    #
    my $my;
    if ( defined ( my $access_token = $c->session->get('access_token') ) ) {
        $my = $db->user->find_one({ token => $access_token->token });
    };

    #
    my $itr_line = $db->line->find->sort({ created_at => -1, id => -1 })->limit(50);

    $vars = +{
        my        => $my,
        lines     => $itr_line,
        coll_user => $db->user,
    };

    my $lang_map = {};
    for my $k ( @{ $c->config->{langs} } ) {
        $lang_map->{$k->{key}} = $k->{name};
    }
    $vars->{lang_map} = $lang_map;
    $vars->{langs}    = $c->config->{langs};


    unless (defined $params and ref $params eq 'HASH') {
        $params = {};
    }

    for my $k ( keys %$vars ) {
        next  if exists $params->{$k};
        $params->{$k} = $vars->{$k};
    }

    return $c->render('index.tx', $params);
}



1;
