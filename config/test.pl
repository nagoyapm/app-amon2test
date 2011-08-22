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
            callback_url       => 'oauth/callback',
        },
    },


    langs => [
        { key => 'pl',    name => 'Perl5' },
        { key => 'p6',    name => 'Perl6' },
        { key => 'coq',   name => 'Coq' },
        { key => 'js',    name => 'JavaScript' },
        { key => 'rb',    name => 'Ruby 1.8.x' },
        { key => 'rb19',  name => 'Ruby 1.9.x' },
        { key => 'py',    name => 'Python 2.x' },
        { key => 'py3',   name => 'Python 3.x' },
        { key => 'php',   name => 'PHP' },

        { key => 'c',     name => 'C' },
        { key => 'grass', name => 'Grass' },
        { key => 'lsp',   name => 'Common Lisp' },
        { key => 'el',    name => 'Emacs Lisp' },
        { key => 'hs',    name => 'Haskell' },
        { key => 'awk',   name => 'Awk' },
        { key => 'bas',   name => 'Basic' },
        { key => 'bf',    name => 'Brainf.ck' },
        { key => 'io',    name => 'IO' },
        { key => 'lazy',  name => 'Lazy K' },
        { key => 'lua',   name => 'Lua' },
        { key => 'm4',    name => 'm4' },
        { key => 'ml',    name => 'OCaml' },
        { key => 'ps',    name => 'PostScript' },
        { key => 'scm',   name => 'Scheme' },
        { key => 'tcl',   name => 'Tcl' },
    ],
};
