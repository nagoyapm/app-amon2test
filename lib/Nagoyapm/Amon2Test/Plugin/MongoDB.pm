package Nagoyapm::Amon2Test::Plugin::MongoDB;
use strict;
use warnings;
use utf8;
use MongoDB;


sub init {
    my ($class, $c, $params) = @_;

    no strict 'refs';
    *{"$c\::db"} = \&_db;
}


sub _db {
    my ($self) = @_;

    if ( !defined $self->{db} ) {
        my $conf = $self->config->{'MongoDB'}
            or die "missing configuration for 'MongoDB'";

        my $dbname = $conf->{database}
            or die "missing 'MongoDB.database'";

        my %params_conn = (
            host => $conf->{host} || 'localhost',
            port => $conf->{port} || '27017',
        );
        $params_conn{username} = $conf->{username}  if $conf->{username};
        $params_conn{password} = $conf->{password}  if $conf->{password};

        my $conn = MongoDB::Connection->new(%params_conn);

        $self->{db} = $conn->$dbname;
    }

    return $self->{db};
}


1;
