class Main
  helpers do
    class Main::LinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
      def html_container( html )
        tag(:ul, html, container_attributes.merge(:class => 'notList pagination'))
      end
      
      def to_html
        html = [].tap do |ret|
          ret << previous_page
          ret << '<li><ul class="notList page-numbers">'
          windowed_page_numbers.each do |item|
            ret << page_number(item)
          end
          ret << "</ul></li>"
          ret << next_page
        end.join("\n")

        @options[:container] ? html_container(html) : html
      end

      def page_number(page)
        unless page == current_page
          tag('li', link(page, page, :rel => rel_value(page), :class => 'ir'))
        else
          tag('li', tag(:span, page, :class => 'ir'))
        end
      end

      def previous_or_next_page(page, text, classname)
        if page
          tag('li', link(text, page), :class => classname)
        else
          tag('li', link(text, '#', :onclick => "return false"), :class => classname + ' disabled')
        end
      end

      def previous_page
        previous_or_next_page(@collection.previous_page, @options[:previous_label], 'prev-link')
      end

      def next_page
        previous_or_next_page(@collection.next_page, @options[:next_label], 'next-link')
      end
    end
    
    def pagination( collection, options = {} )
      options.reverse_merge!(
        :renderer => Main::LinkRenderer,
        :class    => 'notList pagination'
      )

      will_paginate collection, options
    end
  end
end
