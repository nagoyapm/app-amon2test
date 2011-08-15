package Nagoyapm::Amon2Test::Util;
use strict;
use warnings;
use utf8;

use Smart::Args;
use OAuth::Lite::Consumer;
use MongoDB;


sub import {
    my ($class, @subs) = @_;
    my $caller = caller;

    for my $f ( @subs ) {
        no strict 'refs';
        *{"$caller\::$f"} = \&$f;
    }
}



sub new_oauth_consumer {
    args_pos (
        my $conf => { isa => 'HashRef', default => +{} },
        my $type => { isa => 'Str', default => '' },
    );
    my $ret;

    #$conf = +{%{ ( $type ne ''  &&  defined $conf->{$type} ) ? $conf->{$type} : $conf }};
    $conf = $conf->{$type}  if ( $type ne ''  &&  defined $conf->{$type} );

    $ret = OAuth::Lite::Consumer->new(
        map {
            ( $_, $conf->{$_} );
        } qw/consumer_key
             consumer_secret
             request_token_path
             access_token_path
             authorize_path
            /,
    );

    return $ret;
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

=item $oauth_consumer = new_oauth_consumer( \%conf, $type )

Returns OAuth::Lite::Consumer.

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
