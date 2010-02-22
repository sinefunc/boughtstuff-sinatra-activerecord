require 'action_view/helpers/form_helper'

module Theia
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    cattr_accessor :inline_error_proc
    @@inline_error_proc = Proc.new { |error|
      %(<span class='inline-error'>#{error}</span>)
    }

    def errors_for( field_name, options = {} )
      errors = [ object.errors.on( field_name ) ].flatten.compact
      
      if errors.any?
        error = 
          if options[:full]
            object.class.human_attribute_name(field_name) + ' ' + errors.to_sentence
          else
            errors.to_sentence
          end
        
        @@inline_error_proc.call( error ) 
      end
    end

    def label( field_name, text = nil, options = {}, &block )
      options = text if text.is_a?(Hash)
      text    = @template.capture(&block) if block_given?

      super( field_name, text, options )
    end
  end

  module FormHelper
    def fields_for(*args, &block)
      options = args.extract_options!
      options[:builder] ||= ::Theia::FormBuilder
      args << options
      super( *args, &block )
    end
    
    def inline_error( msg )
      Theia::FormBuilder.inline_error_proc.call( msg )
    end
  end
end
