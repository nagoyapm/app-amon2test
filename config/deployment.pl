+{
    'MongoDB' => {
        host     => '95b15d13.dotcloud.com',
        port     => '13639',
        username => 'root',
        password => 'qEjc7VoqYRs4aEKtgcJg',
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
            consumer_key       => '',
            consumer_secret    => '',
            request_token_path => 'https://api.twitter.com/oauth/request_token',
            access_token_path  => 'https://api.twitter.com/oauth/access_token',
            authorize_path     => 'https://api.twitter.com/oauth/authorize',
            callback_url       => 'http://8a02165d.dotcloud.com/oauth/callback',
        },
    },


    langs => [
        { key => 'pl', name => 'Perl5' },
        { key => 'p6', name => 'Perl6' },
        { key => 'js', name => 'JavaScript' },
        { key => 'coq', name => 'Coq' },

        { key => 'awk', name => 'Awk' },
        { key => 'c', name => 'C' },
        { key => 'grass', name => 'Grass' },
        { key => 'el', name => 'Emacs Lisp' },
        { key => 'hs', name => 'Haskell' },
    ],
};
