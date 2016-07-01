var ready = function() {
  $('.loading').on('click', function() {
    var $btn = $(this).button('loading');
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);
