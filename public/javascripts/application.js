(function() {
  $(function() {
	  $.ajaxSettings.accepts._default = "text/javascript, text/html, application/xml, text/xml, */*";
    
    $('form.remote-form').remoteForm();
    
    $('.reply-item a').click(function() {
      $.ubox($(this).attr('href'));
      return false;
    });

    $('a[data-method="delete"]').destroyOnClick();
    $('.like-link, .unlike-link').likeUnlikeLink();


    $('#item_photo').autoUpload({
      'spinner' : $.assetHost('/images/spinner.gif'),
      'field'   : 'item[tempitem_id]'
    });

    $('#item_photo_url').autoScrape({
      'spinner' : $.assetHost('/images/spinner.gif'),
      'field'   : 'item[tempitem_id]'
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
      $sparkly = $('<em class="ir sparkly-focus">Current Item</em>');
      $item.prepend($sparkly);

      window.setInterval(function() {
        $sparkly.animate({ opacity: 0.5 }, 1000, function() {
          $sparkly.animate({opacity: 1.0 }, 1000);
        });
      }, 2000);
    }
  });
})(jQuery);