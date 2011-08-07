+{
    'MongoDB' => {
        host     => 'localhost',
        port     => '27017',
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
};
