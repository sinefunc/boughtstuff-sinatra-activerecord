(function() { 
  $.fn.remoteForm = function() {
    $(this).livequery(function() {
      var $this = $(this),
          $button = $this.find('.button'),
          $spinner = $('<img alt="Please wait..." />').attr(
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
          if (data['location']) {
            $('.initial, .success', '#ubox-container').toggleClass('hide');
          } else {
            $button.removeClass('hide');
            $spinner.remove();

            $('.tool-tip').remove();
            $.each(data, function( field, errors ) {
              $('#' + modelName + '_' + field).inlineError( errors );
            });
          }
        }
      });
    });
  }
})(jQuery);
