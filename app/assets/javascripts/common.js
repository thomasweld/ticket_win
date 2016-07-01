var ready = function() {
}

$(document).ready(ready);
$(document).on('page:load', ready);

$('loading').click(function() {
  var $btn = $(this).button('loading');
});
