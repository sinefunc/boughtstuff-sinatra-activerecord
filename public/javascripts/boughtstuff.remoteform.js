(function($) { 
  $.fn.remoteForm = function() {
    $(this).livequery(function() {
      var $this = $(this),
          $button = $this.find('.button'),
          $spinner = $('<img alt="Please wait..." class="centerize" />').attr(
            'src', $.assetHost('/images/spinner.gif')
          ),
          modelName = $this.attr('rel');

      $this.ajaxForm({
        'url'           : $this.attr('action'),
        'dataType'      : 'json',
        'beforeSubmit'  : function() {
          $button.addClass('hide').after($spinner);
        },

        'success'       : function(data) {
          if (data.location) {
            if ($('#ubox-container').css('display') == 'none') {
              window.location.href = data.location;
            } else {
              $('.initial, .success', '#ubox-container').toggleClass('hide');
              setTimeout(function() { 
                $('#ubox-container, #ubox-screen').fadeOut();
              }, 5000);
            }
          } else {
            $button.removeClass('hide');
            $spinner.remove();

            $('.tool-tip').remove();
            $.each(data, function( field, errors ) {
              $('#' + modelName + '_' + field).inlineError( errors[0] );
            });
          }
        }
      });
    });
  };
})(jQuery);
