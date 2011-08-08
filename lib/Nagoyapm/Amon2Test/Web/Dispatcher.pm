package Nagoyapm::Amon2Test::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::Lite;

any '/' => sub {
    my ($c) = @_;
    $c->render('index.tx');
};


get '/test/lleval' => sub {
    my ($c) = @_;
    $c->render('test/lleval.tx');
};


1;
