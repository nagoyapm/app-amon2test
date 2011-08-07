+{
    'MongoDB' => {
        host     => 'localhost',
        port     => '27017',
        username => '',
        password => '',
        database => 'nagoyapm_osc2011nagoya',
    },

    'DBI' => [
        'dbi:SQLite:dbname=development.db',
        '',
        '',
        +{
            sqlite_unicode => 1,
        }
    ],
};
