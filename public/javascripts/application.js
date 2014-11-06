$(function() {
  $(document).ready(function() {
    $('form').submit(function(e) {
      e.preventDefault();
      var environment = $('#environment').val();
      var service = $('#service').val();
      var port = $('#service').find('option:selected').data('port');
      var op = $('#op').val();
      var expression = $('#expression').val();

      var url = "http://" + environment + ":" + port + "/" + service + "service/" + op + "?" + expression;
      $('#generated-url').html(url);
      $('#fetch-trace').removeClass('disabled');
    });

    $('#fetch-trace').click(function(e) {
      $.ajax({
        url: '/fetch-trace',
        method: 'GET',
        data: {'url': $('#generated-url').html()},
        beforeSend: function() {
          $('#fetch-trace').addClass('disabled');
        },
        success: function(resp) {
          $('#fetch-trace').removeClass('disabled');
          $('#response').html(resp);
        },
        error: function(resp) {
          $('#fetch-trace').removeClass('disabled');
          $('#response').html(resp);
        }
      });
    });
  });
})();
