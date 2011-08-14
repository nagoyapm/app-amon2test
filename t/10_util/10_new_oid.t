use strict;
use warnings;
use utf8;
use Test::More;
use MongoDB::OID;
use Nagoyapm::Amon2Test::Util qw/new_oid/;
use Try::Tiny;


{
    try {
        new_oid;
        ok 'subroutine is available.';
    } catch {
        my $msg = shift;
        fail 'Should pass: ' . $msg;
    }
};



{
    my $oid = new_oid;
    isa_ok $oid, 'MongoDB::OID';
};



{
    my $oid;

    $oid = new_oid( 'foo' );
    is "$oid", 'foo';
    
    $oid = new_oid( 'abcdabcd01234567abcdabcd' );
    is "$oid", 'abcdabcd01234567abcdabcd';

};


done_testing;
__END__
