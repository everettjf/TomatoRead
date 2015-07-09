/**
 * Created by everettjf on 15/7/8.
 */
$.ajaxSetup({
    headers: {
        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
    }
});

$('.ui.dropdown')
    .dropdown()
;