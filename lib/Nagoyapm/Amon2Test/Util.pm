package Nagoyapm::Amon2Test::Util;
use strict;
use warnings;
use utf8;

use Smart::Args;
use MongoDB;


sub import {
    my ($class, @subs) = @_;
    my $caller = caller;

    for my $f ( @subs ) {
        no strict 'refs';
        *{"$caller\::$f"} = \&$f;
    }
}



sub new_oid {
    args_pos (
        my $v => { isa => 'Str', default => '' },
    );
    return new MongoDB::OID->new( value => $v );
}



1;
__END__

=head1 NAME

Nagoyapm::Amon2Test::Util -

=head1 SYNOPSIS

  use Nagoyapm::Amon2Test::Util qw/new_oid/;

  # get MongoDB's Object ID
  my $oid = new_oid( $oid_string );

=head1 DESCRIPTION

Nagoyapm::Amon2Test::Util is a ...

=over 4

=item $oid = new_oid( $oid_string )

Returns MongoDB::OID object which has value $oid_string.

=back

=head1 AUTHOR
...

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

...

=cut
