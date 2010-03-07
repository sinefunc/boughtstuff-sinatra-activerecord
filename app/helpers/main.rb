class Main
  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
    
    def partial(template, locals = {})
      super( template.to_sym, locals ) 
    end

    def haml(template, options = {}, locals = {})
      options[:escape_html] = false unless options.include?(:escape_html)
      super(template, options, locals)
    end
    
    def t( *args )
      I18n::t(*args)
    end

    def link_to( label, url, options = {} )
      %(<a href="#{url}" #{tag_options(options)}>#{label}</a>) 
    end
  
    def inside?( *path_methods )
      path_methods.any? { |path_and_method|
        path, method = path_and_method.split('#') 
          
        if path.blank?
          request.request_method == method.upcase
        elsif method.blank?
          request.fullpath.index(path)
        else
          request.fullpath.index(path) && method.upcase == request.request_method
        end
      }
    end

    def tag( tag, content, options = {}, &block )
      return tag_in_block( tag, content, &block ) if content.is_a?(Hash)

      %(<#{tag} #{tag_options(options)}>#{content} </#{tag}>)
    end

    private
      def tag_options( options )
        options.map { |k, v| "#{k}=\"#{v}\"" }.join(' ')
      end

      def tag_in_block( tag, options = {}, &block )
        tag(tag, capture_haml( &block ), options)
      end
  end
end
