+{
    'MongoDB' => {
        host     => 'localhost',
        port     => '27017',
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
};
