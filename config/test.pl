+{
    'MongoDB' => {
        host     => 'localhost',
        port     => '27017',
        username => '',
        password => '',
        database => 'nagoyapm_osc2011nagoya_test',
    },

    'DBI' => [
        'dbi:SQLite:dbname=test.db',
        '',
        '',
        +{
            sqlite_unicode => 1,
        }
    ],


    'OAuth' => {
        twitter => {
            consumer_key       => '',
            consumer_secret    => '',
            request_token_path => 'https://api.twitter.com/oauth/request_token',
            access_token_path  => 'https://api.twitter.com/oauth/access_token',
            authorize_path     => 'https://api.twitter.com/oauth/authorize',
            callback_url       => 'http://localhost:5000/oauth/callback',
        },
    },
};
