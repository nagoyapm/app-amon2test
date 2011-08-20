$(function () {
    $('#lines table tbody td.eval a').click(function (ev) {
        var $tr = $(this).parents('tr');
        var code = $tr.find('td.line code').text();

        lleval(code, null, function (data) {
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

        });

        return false;
    });
});

