package Nagoyapm::Amon2Test::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::Lite;

get '/' => sub {
    my ($c) = @_;
    return render_top($c);
};

post '/' => sub {
    my ($c) = @_;
    my $params = $c->req->parameters;
    unless (is_valid($params)) {
        my $err = 'invalidated';
        $c->fillin_form($c->req);
        return render_top($c, {err => $err});
    }
    $c->db->foo->insert($params);
    $c->redirect('/');
    # use Data::Dumper;
    # $Data::Dumper::Terse = 1;
    # my $dump = Data::Dumper->Dump([$c->req->parameters]);
    # return render_top($c, {dump => $dump});
};

sub is_valid {
    my ($params) = @_;
    my $required = [qw(name line)];
    foreach my $name (@$required) {
        unless (exists($params->{$name}) and not($params->{$name} eq q())) {
            return 0;
        }
    }
    return 1;
}

sub render_top {
    my ($c, $params) = @_;
    unless (defined $params and ref $params eq 'HASH') {
        $params = {};
    }
    unless (exists($params->{data})) {
        my $data = [reverse $c->db->foo->find->all];
        $params->{data} = $data;
    }
    return $c->render('index.tx', $params);
}

get '/test/lleval' => sub {
    my ($c) = @_;
    $c->render('test/lleval.tx');
};


1;
