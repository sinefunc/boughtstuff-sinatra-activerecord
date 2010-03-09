class Main
  helpers do
    class FormBuilder
      def initialize( model, context )
        @model, @context, @prefix = model, context, model.class.model_name.underscore
      end
      
      def text_field( field, options = {} )
        options.merge!( 
          type:   'text',
          name:   name(field),
          value:  value(field),
          id:     id(field)
        )

        %(<input #{tag_options(options)} />)
      end

      def file_field( field, options = {} )
        options.merge!( 
          type:   'file',
          name:   name(field),
          id:     id(field)
        )

        %(<input #{tag_options(options)} />)
      end

      def text_area( field, options = {} )
        options.merge!( 
          type:   'text',
          name:   name(field),
          id:     id(field)
        )

        %(<textarea #{tag_options(options)}>#{value(field)}</textarea>)
      end


      def errors_for( field, options = {} )
        
      end

      private 
        def method_missing(meth, *args, &blk)
          if @context.respond_to?(meth) or @context.private_methods.include?(meth)
            @context.send(meth, *args, &blk)
          else
            super
          end
        end

        def name( field )
          %(#{@prefix}[#{field}])
        end

        def value( field )
          @model.send( field ) 
        end

        def id( field )
          "#{@prefix}_#{field}" 
        end
    end

    def form_for( model, options = {}, &block )
      html_options = options[:html] || {}
      html_options.merge!(
        :method  => 'post'
      )
      html_options[:enctype] = 'multipart/form-data' if html_options.delete(:multipart)
      
      builder = FormBuilder.new( model, self )
      haml    = capture_haml(builder, &block)
      tag(:form, haml, html_options)
    end
  end
end
