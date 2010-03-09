class Main
  helpers do
    def navigation(&block)
      tag('ul', :class => 'notList clearFix colL main-nav', &block)
    end

    def nav_item( text, url_options, args = nil )
      options = 
        if args == false
          {}
        elsif args 
          active_if(*Array(args))
        else
          active_if( url_options )
        end

      options ||= {}
      options[:class] = "colL #{options[:class]}"

      tag 'li', 
        link_to(text, url_options), 
        options
    end

    def show_toggling
      yield if inside?('/items', '/liked')
    end

    private
      def active_if( *controller_actions )
        if inside?(*controller_actions)
          { :class => 'active' }
        else
          {}
        end
      end
  end
end
