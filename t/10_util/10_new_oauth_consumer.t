use strict;
use warnings;
use utf8;
use Test::More;
use OAuth::Lite::Consumer;
use Nagoyapm::Amon2Test::Util qw/new_oauth_consumer/;
use Try::Tiny;


{
    try {
        ok exists &new_oauth_consumer;
    } catch {
        my $msg = shift;
        fail 'Should pass: ' . $msg;
    }
};



{
    my $consumer = new_oauth_consumer;
    isa_ok $consumer, 'OAuth::Lite::Consumer';
};



{
    my $conf = +{
        consumer_key       => 'foo',
        consumer_secret    => 'bar',
        request_token_path => 'http://example.com/request',
        access_token_path  => 'http://example.com/access_token',
        authorize_path     => 'http://example.com/authorize',
    };
    my $consumer = new_oauth_consumer($conf);

    is $consumer->consumer_key,      'foo';
    is $consumer->consumer_secret,   'bar';
    is $consumer->request_token_url, 'http://example.com/request';
    is $consumer->access_token_url,  'http://example.com/access_token';
    is $consumer->authorization_url, 'http://example.com/authorize';
}



{
    my $conf = +{
        type1 => {
            consumer_key       => 'foo',
            consumer_secret    => 'bar',
            request_token_path => 'http://type1.example.com/request',
            access_token_path  => 'http://type1.example.com/access_token',
            authorize_path     => 'http://type1.example.com/authorize',
        },

        type2 => {
            consumer_key       => 'hoge',
            consumer_secret    => 'fuga',
            request_token_path => 'http://type2.example.com/request',
            access_token_path  => 'http://type2.example.com/access_token',
            authorize_path     => 'http://type2.example.com/authorize',
        },
    };
    my $consumer;

    # type1
    $consumer = new_oauth_consumer($conf, 'type1');

    is $consumer->consumer_key,      'foo';
    is $consumer->consumer_secret,   'bar';
    is $consumer->request_token_url, 'http://type1.example.com/request';
    is $consumer->access_token_url,  'http://type1.example.com/access_token';
    is $consumer->authorization_url, 'http://type1.example.com/authorize';

    # type2
    $consumer = new_oauth_consumer($conf, 'type2');

    is $consumer->consumer_key,      'hoge';
    is $consumer->consumer_secret,   'fuga';
    is $consumer->request_token_url, 'http://type2.example.com/request';
    is $consumer->access_token_url,  'http://type2.example.com/access_token';
    is $consumer->authorization_url, 'http://type2.example.com/authorize';

    # ''
    $consumer = new_oauth_consumer($conf);


    # check $conf
    ok exists $conf->{type1};
    ok exists $conf->{type2};
}



done_testing;
__END__
