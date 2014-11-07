$(function() {
  function encodeExpression(expr) {
    // expr = expr.replace(/({|})/g, encodeURIComponent('$1'));
    expr = expr.replace(/( |\t|\n)/g, "+");
    expr = expr.replace(/{/g, "%7B");
    expr = expr.replace(/}/g, "%7D");
    return expr;
  }

  $(document).ready(function() {
    $('form').submit(function(e) {
      e.preventDefault();
      var environment = $('#environment').val();
      var service = $('#service').val();
      var port = $('#service').find('option:selected').data('port');
      var op = $('#op').val();
      var expression = encodeExpression($('#expression').val());

      var url = "http://" + environment + ":" + port + "/" + service + "service/" + op + "?expression=" + expression;
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
