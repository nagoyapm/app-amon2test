$(function () {
    $('#lines table tbody td.eval a').click(function (ev) {
        var code = $(this).parents('tr').find('td.line code').text();

        lleval(code, null, function (data) {
            // ok
            if ( typeof data.error == 'undefined' ) {
                // if ( data.stderr != '' ) {
                //     alert( data.stderr );
                // }

                // if ( data.stdout != '' ) {
                //     alert(data.stdout);
                // }
            }
            // error
            else {
            }

        });

        return false;
    });
});

