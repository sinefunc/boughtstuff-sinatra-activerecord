(function($) {
  $.Photo = Base.extend({
    constructor: function(input, options) {
      var ALLOWED = /\.(jpg|png|gif|bmp)$/i,
          $base            = $(input),
          $form            = $base.parents('form'),
          $imagePreview    = $('.item-preview .item-link'),
          $imagePreviewImg = $('.item-preview .item-link img'),
          $zoomLink        = $('.item-preview .zoom-link'),
          $replacement     = $(
            '<span><span class="filename"></span>&nbsp;' +
            '<a class="delete-preview" href="#">Delete</a>' +
            '<input type="hidden" name="' + options['field'] + '" value="" /></span>'
          ),
          $spinner         = $('<img src="" alt="Please wait..." />').
                                    attr('src', options['spinner']);
      this.$form = $form;

      this.canBeSubmitted = function() {
        return ($base.val() && $base.val().match(ALLOWED));
      };

      this.beforeSubmit = function() {
        setTimeout(function() {
          $base.attr('disabled', true).addClass('hide').after($spinner);
        }, 500);
      };

      this.success = function(data) {
        if (data['thumb']) {
          // TODO : extract this selector out
          $('span.filename').deletePreview('#item_photo, #item_photo_url', 
                             $.assetHost('/photos/thumb/missing.jpg'));
        
          $imagePreviewImg.hide().attr('src', data['thumb']).fadeIn();

          $imagePreview.attr('href', data['original']);
          $zoomLink.attr('href', data['original']);

          $base.after(
            $replacement.find('.filename').text(data['filename']).end().
              find('input[type=hidden]').val(data['id']).end()
          );
          $base.addClass('hide');
        } else {
          console.log(data);
          alert("There were problems with uploading the file\n\n");
        }
        $spinner.remove();
      };
    },

    submit: function() {
      if (this.canBeSubmitted()) {
        this.$form.ajaxSubmit({
          'iframe': true,
          'data'  : { 'format': 'iframe' },
          'dataType': 'json',
          'url': '/tempitems',
          'beforeSubmit': this.beforeSubmit,
          'success': this.success
        });
      }
    }
  });
})(jQuery);
