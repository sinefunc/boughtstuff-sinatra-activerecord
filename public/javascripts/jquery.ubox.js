/*
 * uBox jQuery lightbox plugin (v0.1.6)
 * Requires jQuery 1.3+
 *
 * Quick HTML usage guide:
 *   <div id="overlay" style="display:none">I'm hidden but will be shown later</div>
 *   <a href="#overlay" rel="ubox">Open div#overlay in a popup</a>
 *   <a href="via_ajax.html" rel="ubox">Load via AJAX</a>
 *
 * Quick JS usage guide:
 *   $.ubox("#overlay");
 *   $("#overlay").ubox();
 *   $.ubox("load_via_ajax.html");
 *   $.ubox.hide();
 */
 
(function($)
{
    $.ubox = function(p) { return $.ubox.show(p); }
    $.fn.ubox = function() { $.ubox(this); }
    $.ubox.default_options =
    {
        screen_speed:     500,   // Speed of the black screen's fading in/out
        popup_speed:      500,   // Speed of the popup's fading in/out (no effect in IE)
        transition_speed: 500,   // Speed of loading the content, and going from one screen to another
        delay:            100,   // Delay in AJAX loading time
        allow_clickout:   true,  // Allow clicking on the background to close
        screen_opacity:   0.7,   // Opacity of the black screen (0...1)
        screen_color:     "#000",// Color of the black screen

        // Hooks
        on_popup: function() {},
        on_resize: function() {}
    };
	    
    $.extend($.ubox,
    {
        // Properties
        $screen:    null,  // #ubox-screen, The bg screen
        $container: null,  // #ubox-container
        $subcon:    null,  // #ubox-container > #ubox-subcontainer
        $content:   null,  // #ubox-container > #ubox-subcontainer > #ubox-content popup window (null if not active), returned by _loadWindow
        $original:  null,  // What was loaded
        _ietimer:   null,  // Timer for IE

        options: {},
        
		/**
		 * Opens the window and puts the right content in it.
		 * Returns the #ubox-content element.
		 * Called by show(). show() will take care of starting the screen and
		 * other things
		 * @private
		 */
        _loadWindow: function (target)
        {	
            // What is returned (.ubox-content) will be referred to as $content and
            // appended to this.$subcon.
            
            // If given a jQuery object...
            if ((typeof target == "object") && (target.css))
                { return this._loadWindowViaElement(target); }

            // Must be string from this point forward
            if (typeof target != "string")
                { return null; }
        
            // If it isn't preceded by a #, then it's a URL
            if (target.substr(0,1) != '#')
                { return this._loadWindowViaURL(target); }

            // If preceded by #, it's an ID
            try
            {
                // Try to query it. This can throw an exception.
                var el = $(target);

                // If match: then go
                if (el.length > 0)
                    { return this._loadWindowViaElement(el); }
            }

            // Catch a jQuery "can't parse" exception.
            catch (e) {}

            return null;
        },

        // Target should be a jQuery object
        _loadWindowViaElement: function (target)
        {
            // Continue
            this.$original = target;
            return $('<div class="ubox-content">').append(this.$original.show()).show();
        },

        _loadWindowViaURL: function (target)
        {
            // AJAX.
            // Make it up. (.ubox-deferred means it's an async load, i.e., AJAX)
            var el = $('<div class="ubox-content ubox-deferred">').hide();

            var self = this;
            
            window.setTimeout(function()
            {
                $.get(target, function(data)
                {
                    if (!self.$content) { return; }
                    // Load the stuff (it's hidden right now btw)
                    el.html(data);
                
                    // Delete the loader
                    loader = self.$subcon.find(".ubox-loader");
                    loader.hide();
                
                    // Make the content fit the loader
                    self.$subcon
                      .css({
                        "width":  loader.outerWidth(),
                        "height": loader.outerHeight()
                      });

                    // Then expand
                    $.ubox.autoResize();
                });
            }, self.options.delay);
            
            return el;
        },

        /**
         * Automatically resizes the open popup.
         * $.ubox.autoResize();
         */
        autoResize: function()
        {
            var $el = $('.ubox-content');
            this.resize($el.outerWidth(), $el.outerHeight());
        },

        resize: function(width, height)
        {
            var self = this;
            var el = self.$content;
            var $c = self.$container;
            var cpos =
            {
                "top":  parseInt($c.css('top')),
                "left": parseInt($c.css('left'))
            };
            var targetpos =
            {
                "top":  (height - parseInt(self.$subcon.css('height'))),
                "left": (width  - parseInt(self.$subcon.css('width')))
            };
         
            self.$subcon.animate(
                {
                    "width":  width,
                    "height": height
                },
                {
                    "duration": self.options.transition_speed,
                    "step": function(now, fx) {
                        // Animate the top/left position ourselves
                        var pos = (now - fx.start) / (fx.end - fx.start);
                        $c.css("top",  cpos.top  - targetpos.top  /2*pos);
                        $c.css("left", cpos.left - targetpos.left /2*pos);
                    },
                    "complete": function() {
                        el.fadeIn(self.options.transition_speed);
                        self.options.on_resize();
                    }
                }
              );
        },
        
    	/**
    	 * Loads the popup.
    	 * Called by onclick events.
    	 *
    	 * @par Example
    	 * // Loads the "my-overlay" box.
    	 * $.ubox.show('#my-overlay');
    	 */
	    show: function(target, custom_options)
    	{
            // Set defaults
            // (These can also be combined with the default options in the future...)
            if (!custom_options) { custom_options = {}; }

            // Reset the options
            this.options = $.extend($.extend({}, this.default_options), custom_options);
            var options = this.options;

    		// Loads popup only if it is disabled.
    		if (!this.$content)
    		{
    		    var ubox_content = this._loadWindow(target);
                if (!ubox_content) { return false; }
                this.$content = ubox_content;

    		    // Activate the background popup
    			this.$screen.css(
    			{
    				"opacity":    this.options.screen_opacity,
    				"position":   "absolute",
    				"height":     $(document).height()+"px",
    				"background": this.options.screen_color,
    				"width":      "100%",
    				"top":        0,
    				"left":       0,
    				"z-index":    10001
    			});
			
    			// IE6 fix for dropdown boxes: Use bgiframe.
    		    if (($.browser.msie) && ($.browser.version < 6.5))
    			    { this.$screen.bgiframe(); }

                // Show screen
    			this.$screen.fadeIn(this.options.screen_speed, function() {});

                // Dynamicly-generated box for async (AJAX) loads
                if (this.$content.is(".ubox-deferred")) {
                    this.$subcon.append($('<div class="ubox-loader">'));
		            this.$subcon.append(this.$content);
                }
                
                // Box that's pulled from the content
                else {
                    // Shows, but this will not be shown as it's container
                    // is still invisible.
                    // Blah blah: Get classname from link
                    //var classname = $(target)[0].className; this.$content.find(">*:first-child").attr('class');
                    var classname = this.$content.find(">*:first-child").attr('class');
                    this.$container.addClass(classname);
		            this.$subcon.append(this.$content);
                }
                
                // Show popup window
                this._centerPopup();
    		}
		
    		// If the popup is already shown
    		else
    		{
    			// Abruptly make the old popup disappear
    			if (this.$original)
    			    { $(document.body).append(this.$original.hide()); }
    			
    			var new_content = this._loadWindow(target);
    			this.$content = new_content;
    			
    			this.$subcon.empty();
    			if (new_content.is(".ubox-deferred")) {
    			    loader = $('<div class="ubox-loader">').hide();
    			    this.$subcon.append(loader);
    			    ox = loader.outerWidth()  - loader.width();
    			    oy = loader.outerHeight() - loader.height();
    			    loader.css({ "width": this.$subcon.width()-ox,
    			        "height": this.$subcon.height()-oy });
    			    loader.fadeIn(this.options.transition_speed);
                    this.$subcon.append(new_content);
			    }
                else {
                    this.$subcon.append(new_content);
                    this._centerPopup();
                }
			
    			// Quickly switch to the new popup
    		}

            // We're done
            this.options.on_popup();
    	},
    	
    	/**
    	 * Gets rid of the popup.
    	 */
    	
    	kill: function()
    	{    
    		// Disable the popup only if it is enabled
    		if (!this.$content) { return; }
		
    		// Disable the IE timer if it's been turned on.
    		if (this._ietimer)
    		    { window.clearTimeout(this._ietimer); }
		
    		// Fade out the windows.
			var self = this;
    		this.$screen.fadeOut(this.options.screen_speed);
    		this.$container.fadeOut(this.options.popup_speed, function() {
    		    self.$content.hide();
    		    // Clear, and clear any dimensions set by the ajax thing
    		    self.$subcon.html('');
    		    self.$subcon.css({"width":"","height":""});
    		    
    		    // If we pulled something from the source, put it back
    		    if (self.$original) {
    		        $(document.body).append(self.$original.hide());
    		        self.$original = null;
		        }
		        
    		    self.$content = null;
    		});    		
	    },
	    
	    /**
	     * Called on document ready; initializes the hooks.
	     * @private
	     */
	     
	    _init: function()
	    {
	        if ($.browser.msie)
	            { this.options.popup_speed = 0; }
	            
			var self = this;
			
    	    // Screen
    		this.$screen =
    		    $('<div id="ubox-screen">')
    		        .css({ "display": "none" })
    		        .insertBefore($(document.body.firstChild));
    		        
    	    // Border
    		this.$container =
    		    $('<div id="ubox-container">')
    		        .css({ "display": "none" })
    		        .insertBefore($(document.body.firstChild));
    		
    		this.$subcon = $('<div id="ubox-subcontainer">');
    		        //.css({ "overflow": "hidden" });
    		    
    		this.$container.append(this.$subcon);
    		
    		$("a.popup-button, a[rel~=ubox]").live("click", function()
    		{
				self.show($(this).attr('href'));
				$(this).blur(); // Remove focus from the link
				return false;
			});
		
    		$("input.popup-button").click(function()
    		{
				self.show($(this.form).attr('action'));
				$(this).blur();
				return false;
			});
		
    		$(".popup-close, a[rel~=ubox-close]").live("click", function()
    		{
				$(this).blur();
				self.kill();
				return false;
			});
		
    		// Click out
    		this.$screen.click(function()
    		{
				if (self.options.allow_clickout)
					{ self.kill(); }
			});

    		// Escape key
    		$(document).keypress(function(e)
    		{
    			if ((e.keyCode == 27) && (self.$content))
    				{ self.kill(); }
    		});
        },
	    
	    /**
	     * Initializes the popup window.
	     * Makes `$container` visible and placed in the center.
	     * @private
	     */
	     
	    _centerPopup: function()
    	{
    		var popup = this.$container;
    		var windowWidth  = document.documentElement.clientWidth;
    		var windowHeight = document.documentElement.clientHeight;
    		var popupHeight  = popup.outerHeight();
    		var popupWidth   = popup.outerWidth();

    		popup.css({
    			"position": "fixed",
    			"top": windowHeight/2-popupHeight/2,
    			"left": windowWidth/2-popupWidth/2
    		});
		
    		// MSIE does not support `position: fixed`, so we work around it.
    		if ($.browser.msie)
			{
    			popup.css({
    				  "position": "absolute",
    				  "top": windowHeight/2-popupHeight/2 + $(window).scrollTop()
    			});
    			if (!this._ietimer) this._ietimer = window.setInterval(function()
        		{
    		        var popupHeight  = popup.outerHeight();
    		        var popupWidth   = popup.outerWidth();
        			var windowWidth = document.documentElement.clientWidth;
        			var windowHeight = document.documentElement.clientHeight;
        			target = windowHeight/2-popupHeight/2 + $(window).scrollTop();
        			popup.css({ "left": windowWidth/2 - popupWidth/2 });
        			if ($.browser.msie) {
        				from = parseInt(popup.css('top'));
        				if (Math.abs(target-from) > 1)
        					{ popup.css({ "top": (from + (target - from) * 0.4) + "px" }); }
        				else
        					{ popup.css({ "top": target + "px" }); }
        			}
        			else {
        				popup.css({ "top": (windowHeight/2-popupHeight/2) + "px" });
        			}
        		}, 25);
    		}
		
			// Fade in
    		popup.css({ "z-index": 10003 }).fadeIn(this.options.popup_speed);
    	}
    });

	// Let's rock.
	$(function() { $.ubox._init(); });
	
})(jQuery);

/* The bgiframe plugin has been added in here. */

/*! Copyright (c) 2008 Brandon Aaron (http://brandonaaron.net)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) 
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 * Version 2.1.2-pre
 */
(function($){

/**
 * @name bgiframe
 * @type jQuery
 * @cat Plugins/bgiframe
 * @author Brandon Aaron (brandon.aaron@gmail.com || http://brandonaaron.net)
 */
$.fn.bgIframe = $.fn.bgiframe = function(s) {
	// This is only for IE6
	if ( $.browser.msie && /6.0/.test(navigator.userAgent) ) {
		s = $.extend({
			top     : 'auto', // auto == .currentStyle.borderTopWidth
			left    : 'auto', // auto == .currentStyle.borderLeftWidth
			width   : 'auto', // auto == offsetWidth
			height  : 'auto', // auto == offsetHeight
			opacity : true,
			src     : 'javascript:false;'
		}, s || {});
		var prop = function(n){return n&&n.constructor==Number?n+'px':n;},
		    html = '<iframe class="bgiframe"frameborder="0"tabindex="-1"src="'+s.src+'"'+
		               'style="display:block;position:absolute;z-index:-1;'+
			               (s.opacity !== false?'filter:Alpha(Opacity=\'0\');':'')+
					       'top:'+(s.top=='auto'?'expression(((parseInt(this.parentNode.currentStyle.borderTopWidth)||0)*-1)+\'px\')':prop(s.top))+';'+
					       'left:'+(s.left=='auto'?'expression(((parseInt(this.parentNode.currentStyle.borderLeftWidth)||0)*-1)+\'px\')':prop(s.left))+';'+
					       'width:'+(s.width=='auto'?'expression(this.parentNode.offsetWidth+\'px\')':prop(s.width))+';'+
					       'height:'+(s.height=='auto'?'expression(this.parentNode.offsetHeight+\'px\')':prop(s.height))+';'+
					'"/>';
		return this.each(function() {
			if ( $('> iframe.bgiframe', this).length == 0 )
				this.insertBefore( document.createElement(html), this.firstChild );
		});
	}
	return this;
};

})(jQuery);

