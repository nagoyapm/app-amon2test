use strict;
use warnings;
use Test::More;

use_ok $_ for qw(
    Nagoyapm::Amon2Test
    Nagoyapm::Amon2Test::Web
    Nagoyapm::Amon2Test::Web::Dispatcher
);

done_testing;
