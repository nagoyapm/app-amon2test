function lleval (code, lang, cb) {
    code = '#!/usr/bin/' + (lang || 'perl') + '\n' + code;

    //http://api.dan.co.jp/lleval.cgi?c=callback&s=%23!/usr/bin/perl%0d%0aprint%20%22foo%22
    var ajax_params = {
        url: 'http://api.dan.co.jp/lleval.cgi',
        type: 'get',
        dataType: 'json',
        data: {
            s: code
        },
        success: function (res, status, xhr) {
            // res:
            //   lang: "perl "
            //   status: 0
            //   stderr: ""
            //   stdout: "$VAR1 = [↵          'a',↵          'b',↵          'c'↵        ];↵"
            //   syscalls: 434
            //   time: 0.0502378940582275
            if ( typeof cb == 'function' ) {
                cb(res);
            }
        },
        error: function (xhr, status) {
        }
    };
    $.ajax(ajax_params);


    return false;
}
