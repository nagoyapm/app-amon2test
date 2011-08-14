use strict;
use warnings;
use utf8;
use Test::More;
use Try::Tiny;

use Nagoyapm::Amon2Test::Util;

my @subs_test = qw/
    new_oid
/;


for my $f (@subs_test) {
    try {
        no strict 'refs';
        $f->();
        fail 'subroutine shoud not be available';
    } catch {
        my $msg = shift;
        like $msg, qr/Undefined subroutine/;
    }
}


done_testing;
__END__
