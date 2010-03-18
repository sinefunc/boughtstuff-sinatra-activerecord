(function($) {
  $(function() {
	  $.ajaxSettings.accepts._default = "text/javascript, text/html, application/xml, text/xml, */*";
    
    $('form.remote-form').remoteForm();
    
    $('.delete-item a').click(function() {
      if (window.confirm('Are you sure you want to delete this item?')) {
        $.ajax({
          'url':       $(this).attr('href'),
          'type':     'DELETE',
          'dataType': 'json',
          'success':  function(data) {
            window.location.href = data.location;
          }
        });
      } 

      return false;
    });

    $('.reply-item a').click(function() {
      $.ubox($(this).attr('href'));
      return false;
    });

    $('.rt-item a').click(function() {
      var $this = $(this);

      $.ajax({
        'url':      $this.attr('href'),
        'type':     'POST',
        'success':  function(data) {
          $.ubox($this.attr('href'));
          setTimeout(function() { 
            $('#ubox-container, #ubox-screen').fadeOut(); 
          }, 5000);
        }
      });

      return false;
    });

    $('a[data-method="delete"]').destroyOnClick();
    $('.like-link, .unlike-link').likeUnlikeLink();


    $('#item_photo').autoUpload({
      'spinner' : $.assetHost('/images/spinner.gif'),
      'field'   : 'item[temp_photo_file_name]'
    });

    $('#item_photo_url').autoScrape({
      'spinner' : $.assetHost('/images/spinner.gif'),
      'field'   : 'item[temp_photo_file_name]'
    });

    $('.delete-preview').live('click', function() {
      $(this).deletePreview(
        '#item_photo, #item_photo_url', $.assetHost('/photos/thumb/missing.jpg')
      );
      return false;
    });

    $('.tool-tip').live('click', function() {
      $('.tool-tip').fadeOut();

      return false;
    });

    $('label > em.faux-value').parents('label').inFieldLabels();

    $('#new_item').submitWithIframe(); 
  
    var matches = window.location.href.match(/#([0-9]+)$/); 

    if (matches && matches[1]) {
      $.get('/items/' + matches[1], 'format=js');
      
      var $item = $('#item_' + matches[1]);
      var $sparkly = $('<em class="ir sparkly-focus">Current Item</em>');
      $item.prepend($sparkly);

      window.setInterval(function() {
        $sparkly.animate({ opacity: 0.5 }, 1000, function() {
          $sparkly.animate({opacity: 1.0 }, 1000);
        });
      }, 2000);
    }
  });
})(jQuery);
