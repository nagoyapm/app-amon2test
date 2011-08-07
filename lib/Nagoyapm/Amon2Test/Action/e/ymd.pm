package Nagoyapm::Amon2Test::Action::e::ymd;
use strict;
use warnings;
use utf8;
use Data::Dumper;

sub get {
    my ($c, $q) = @_;
    my %vars;

    $vars{date} = sprintf '%04d年%2d月%2d日', @$q{qw/y m d/};

    $c->render('ymd.tx', \%vars);
}


# sub post {
# }


# sub any {

#     '';
# }



1;
