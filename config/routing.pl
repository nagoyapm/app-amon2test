[
    [
        '/',
        qr{^ /(?:index)? $}x,
    ] => {
        action => 'index',
    },


    [
        qr{ /e/(\d{4})-(\d{2})-(\d{2}) }x,
        '/e/{y:\d{4}}--{m:\d{2}}--{d:\d{2}}',
    ] => {
        action => 'e::ymd',
        params => [qw/y m d/],
    },
];
