+{
    'MongoDB' => {
        host     => 'localhost',
        port     => '27017',
        username => '',
        password => '',
        database => 'osc2011nagoya',
    },

    'DBI' => [
        'dbi:SQLite:dbname=deployment.db',
        '',
        '',
        +{
            sqlite_unicode => 1,
        }
    ],


    'OAuth' => {
        twitter => {
            consumer_key       => '9EQPWHRr05mccgdEyGcOg',
            consumer_secret    => 'D9rbn2k247F7nuA23qIrQteMML3Uys8aPcMwUJQcVc',
            request_token_path => 'https://api.twitter.com/oauth/request_token',
            access_token_path  => 'https://api.twitter.com/oauth/access_token',
            authorize_path     => 'https://api.twitter.com/oauth/authorize',
            callback_url       => 'http://8a02165d.dotcloud.com/oauth/callback',
        },
    },
};
