module Webrat
  module Rspec2Matchers
    def contain( text )
      Rspec::Matchers::Matcher.new :contain, text do |_text_|
        match do |_response_|
          @document = Webrat::XML.document(_response_)
          @element = @document.inner_text

          case _text_
          when String
            @element.gsub(/\s+/, ' ').include?(_text_)
          when Regexp
            @element.match(_text_)
          end
        end

        failure_message_for_should do
          "expected the following element's content to #{content_message(_text_)}:\n#{squeeze_space(@element)}"
        end

        failure_message_for_should_not do
          "expected the following element's content to not include #{content_message(_text_)}:\n#{squeeze_space(@element)}"
        end

        def squeeze_space(inner_text)
          inner_text.gsub(/^\s*$/, "").squeeze("\n")
        end

        def content_message( content )
          case content
          when String
            "include \"#{content}\""
          when Regexp
            "match #{content.inspect}"
          end
        end
      end
    end
    
  end
end

