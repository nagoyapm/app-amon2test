+{
    'MongoDB' => {
        host     => 'localhost',
        port     => '27017',
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
