(function() { 
  $.fn.destroyOnClick = function() {
    $('a[data-method="delete"]').click(function() {
      var csrfParam = $('meta[name=csrf-param]').attr('content'),
          csrfToken = $('meta[name=csrf-token]').attr('content'),
          $form = $(
            '<form action="" method="POST" style="display1: none">' +
            '<input type="hidden" name="_method" value="delete" />' +
            '<input type="hidden" name="_csrfParam" />' +
            '<input type="submit" />' +
            '</form>'
          );
      
      $form.attr('action', $(this).attr('href')).
        find('input[name=_csrfParam]').
        attr('name', csrfParam).val(csrfToken);

      $('body').append($form);
      $form.submit();

      return false;
    });
  }

  $.fn.deletePreview = function(fileInput, imageUrl) {
    var $this            = $(this),
        $imagePreview    = $('.item-preview .item-link'),
        $imagePreviewImg = $('.item-preview .item-link img'),
        $zoomLink        = $('.item-preview .zoom-link');
    
    $(fileInput).removeClass('hide').removeAttr('disabled').val('');
    
    $imagePreview.attr('href', imageUrl);
    $imagePreviewImg.attr('src', imageUrl);
    $zoomLink.attr('href', imageUrl);
    $this.parents('span').remove();
  }

  $.fn.autoUpload = function(options) {
    var photo = new $.Photo(this, options),
        $base = $(this);

    $base.change(function() {
      photo.submit();
    });
  }

  $.fn.autoScrape = function(options) {
    var photo = new $.Photo(this, options),
        $base = $(this);
    
    $base.blur(function() {
      photo.submit();
    });
  }

  $.fn.likeUnlikeLink = function() {
    $(this).click(function() {
      var $this   = $(this),
          $ul     = $this.parents('ul.actions-menu, ul.item-actions').
                      find('li.like-item');

      if ($this.attr('href').match(/\?/)) {
        $.post($this.attr('href'), 'format=js');
      } else {
        $.ajax({
          'url': $this.attr('href'),
          'type': 'DELETE',
          'data': 'format=js'
        });
      }

      $ul.toggleClass('hide');

      return false;
    });
  }

  $.fn.inlineError = function( msg ) {
    var $html = 
      $("<span class='tool-tip'><a href='#' tabindex='9999'></a></span>");
    
    $("label[for='" + $(this).attr('id') + "']").append( 
      $html.find('a').html( msg ).end()
    );
  }
  
  $.fn.submitWithIframe = function() {
    $(this).submit(function() {
      var $this       = $(this),
          $buttonLine = $this.find('.spinner, input.button');
    
      $this.ajaxSubmit({
        'url'   : $this.attr('action'),
        'data'  : { 'format': 'iframe' },
        'dataType': 'json',
        'iframe': true,
        'beforeSubmit': function() {
          $buttonLine.toggleClass('hide');
        },
        'success': function(data) {
          $buttonLine.toggleClass('hide');

          if (data['location']) {
            window.location.href = data['location'];
          } else {
            $('.tool-tip').remove();
            $.each(data, function( field, errors ) {
              $('#item_' + field.replace('_file_name', '')).
                inlineError( errors );
            });
          }
        }
      });
      return false;
    });
  }

  $.assetHost = function( assetPath ) {
    var assetHost = $('meta[name=asset-host]').attr('content');

    return assetHost + assetPath;
  }
})(jQuery);
