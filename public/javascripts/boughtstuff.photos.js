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
            '<input type="hidden" name="' + options.field + '" value="" /></span>'
          ),
          $spinner         = $(
            '<img src="" alt="Please wait..." />'
          ).attr('src', options.spinner);

      this.$form = $form;

      this.canBeSubmitted = function() {
        return ($base.val() && $base.val().match(ALLOWED));
      };

      this.beforeSubmit = function() {
        console.log(" ---> in before submit...");
        window.setTimeout(function() {
          $base.attr('disabled', true).addClass('hide').after($spinner);
        }, 500);
        console.log("      done with before submit!");
      };

      this.success = function(data) {
        console.log(" ---> in success function");
        
        var responseText = $(data).text();
        var data = JSON.parse(responseText);

        if (data.thumb) {
          // TODO : extract this selector out
          $('span.filename').deletePreview('#item_photo, #item_photo_url', 
                             $.assetHost('/photos/thumb/missing.jpg'));
        
          $imagePreviewImg.hide().attr('src', data.thumb).fadeIn();

          $imagePreview.attr('href', data.original);
          $zoomLink.attr('href', data.original);

          $base.after(
            $replacement.find('.filename').text(data.title).end().
              find('input[type=hidden]').val(data.filename).end()
          );
          $base.addClass('hide').attr('disabled', true);
        } else {
          window.alert("There were problems with uploading the file\n\n");
        }
        $spinner.remove();
      };
    },

    submit: function() {
      console.log(" ---> in submit...");
      if (this.canBeSubmitted()) {
        console.log(" ---> can be submitted");
        this.$form.ajaxSubmit({
          'iframe': true,
          'url': '/uploader',
          'beforeSubmit': this.beforeSubmit,
          'success': this.success
        });
      }
      console.log(" ---> finished executing ajax Submit");
    }
  });
})(jQuery);
