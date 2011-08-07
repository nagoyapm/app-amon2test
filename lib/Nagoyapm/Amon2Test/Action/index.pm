package Nagoyapm::Amon2Test::Action::index;
use strict;
use warnings;
use utf8;
use Data::Dumper;

sub get {
    my ($c, $q) = @_;

    $c->render('index.tx');
}


# sub post {
# }


# sub any {
# }



1;
