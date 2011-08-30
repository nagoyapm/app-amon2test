function lleval (code, lang, cb, cb_err) {
    var langmap = {
        pl: 'perl5',
        p6: 'perl6',
    };

    var ajax_request_type = 'json';

    //code = '#!/usr/bin/' + (lang || 'perl5') + '\n' + code;

    //http://api.dan.co.jp/lleval.cgi?c=callback&s=%23!/usr/bin/perl%0d%0aprint%20%22foo%22
    var target_url = 'http://api.dan.co.jp/lleval.cgi';
    if ( lang == 'coq' ) {
        ajax_request_type = 'jsonp';
        target_url = 'http://proofcafe.org/cgi-bin/coqtop/index.cgi';

        if ( typeof cb == 'function' ) {
            window.__lleval_callback = cb;
        }
    }


    var ajax_params = {
        url: target_url,
        type: 'get',
        dataType: ajax_request_type,
        data: {
            //c: 'callback',
            l: lang,
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

            if ( ajax_request_type == 'json'  &&  typeof cb == 'function' ) {
                cb(res);
            }
        },
        error: function (xhr, status) {
            if ( ajax_request_type == 'json'  &&  typeof cb_err == 'function' ) {
                cb_err(xhr, status);
            }
        }
    };

    if ( ajax_request_type == 'jsonp' ) {
        ajax_params.data.c = '__lleval_callback';
    }

    $.ajax(ajax_params);


    return false;
}
