package Nagoyapm::Amon2Test::Web::Dispatcher;
use strict;
use warnings;
use Amon2::Web::Dispatcher::Lite;
use Data::OptList;
use UNIVERSAL::require;
use Try::Tiny;


my $routing = Data::OptList::mkopt(  ( do caller->base_dir . '/config/routing.pl' )  ||  []  );


sub filter_params {
    my ($q, $names) = @_;
    $names ||= [];
    my $q_fix = {%$q};
    delete $q_fix->{code};

    return $q_fix  unless exists $q_fix->{splat};

    my $i = 0;
    for ( @{ $q->{splat} || [] } ) {
        $names->[$i]  ||  last;
        $q_fix->{ $names->[$i] } = $_;
        $i++;
    }
    delete $q_fix->{splat};

    return $q_fix;
}


for my $i ( @$routing ) {
    my ($path, $opts) = @$i;
    $path = [ $path ]  if (ref $path) eq '';


    my $action_class = $opts->{action};
    $action_class = 'Nagoyapm::Amon2Test::Action::' . $action_class
        if $action_class !~ /^\+/;
    $action_class =~ s/^\+//;

    try {
        $action_class->use  or  die $@;

        my $sub_exists = +{
            any  => ( exists &{"$action_class\::any"} ),
            get  => ( exists &{"$action_class\::get"} ),
            post => ( exists &{"$action_class\::post"} ),
        };


        # any
        if ( $sub_exists->{any} ) {
            for my $_path ( @$path ) {
                any $_path => sub {
                    my ($c, $q) = @_;
                    $q = filter_params($q, $opts->{params});
                    {
                        no strict 'refs';
                        *{"$action_class\::any"}->($c, $q);
                    };
                };
            }
        }
        else {
            # get
            if ( $sub_exists->{get} ) {
                for my $_path ( @$path ) {
                    get $_path => sub {
                        my ($c, $q) = @_;
                        $q = filter_params($q, $opts->{params});
                        {
                            no strict 'refs';
                            *{"$action_class\::get"}->($c, $q);
                        };
                    };
                }
            }

            # post
            if ( $sub_exists->{post} ) {
                for my $_path ( @$path ) {
                    post $_path => sub {
                        my ($c, $q) = @_;
                        $q = filter_params($q, $opts->{params});
                        {
                            no strict 'refs';
                            *{"$action_class\::post"}->($c, $q);
                        };
                    };
                }
            }
        }
    } catch {
        die shift;
        #warn qq{Action "${action_class}" is not defined, skip.};
    };
}


1;
