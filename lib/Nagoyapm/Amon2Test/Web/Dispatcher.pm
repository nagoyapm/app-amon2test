package Nagoyapm::Amon2Test::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::Lite;
use Nagoyapm::Amon2Test::Util qw/new_oid/;
use Time::Piece;
use Data::Dumper;

get '/' => sub {
    my ($c) = @_;
    my ($req, $db) = ($c->req, $c->db);


    my $itr_line = $db->line->find->sort({ created_at => -1, id => -1 })->limit(20);


    my $vars = +{
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


1;
