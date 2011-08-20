$(function () {
    $('#lines table tbody td.eval a').click(function (ev) {
        var $tr = $(this).parents('tr');
        var lang = $.trim( $tr.find('td.lang .lang_key').text() || 'perl5' );
        var code = $tr.find('td.line code').text();

        lleval(
            code,
            lang,
            function (data) {
                //alert('callback');
                console.log(data.stdout);

                // ok
                if ( typeof data.error == 'undefined' ) {
                    if ( data.stderr != '' ) {
                        $tr.find('.line .lleval-stderr').text(data.stderr).slideDown();
                    }

                    if ( data.stdout != '' ) {
                        $tr.find('.line .lleval-stdout').text(data.stdout).slideDown();
                    }
                }
                // error
                else {
                    $tr.find('.line .lleval-stderr').text('何かエラーがおきました．．．').slideDown();
                }
            },
            function (xhr, status) {
                console.log(xhr);
                var msg = '何かエラーがおきました．．．';
                msg += ': ' + [ xhr.status, xhr.statusText ].join(',');
                $tr.find('.line .lleval-stderr').text(msg).slideDown();
            }
        );

        return false;
    });
});
