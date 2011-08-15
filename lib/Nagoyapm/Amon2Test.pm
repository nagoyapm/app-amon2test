package Nagoyapm::Amon2Test;
use strict;
use warnings;
use parent qw/Amon2/;
our $VERSION='0.01';
use 5.008001;

__PACKAGE__->load_plugin(
    '+Nagoyapm::Amon2Test::Plugin::MongoDB',
    'Plugin::HTMLFillInFormLite',
);

1;
