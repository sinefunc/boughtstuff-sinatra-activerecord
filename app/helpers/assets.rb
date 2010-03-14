class Main
  helpers do
    def image_tag( path, options = {} )
      raise ArgumentError, "no path given" unless path

      src = 
        if path.index('/') == 0
          "#{app_config(:asset_host)}#{path}"
        elsif path.index('http') == 0
          path
        else
          "#{app_config(:asset_host)}/images/#{path}"
        end

      %(<img src="#{src}" #{tag_options(options)} />)
    end
  
    configure :development, :test do
      def stylesheet_link_merged( group )
        asset_packages_config['stylesheets'].first[group.to_s].map do |file|
          stylesheet_link_tag(file)
        end.join("\n")
      end

      def javascript_include_merged( group )
        asset_packages_config['javascripts'].first[group.to_s].map do |file|
          javascript_include_tag(file)
        end.join("\n")
      end
    end

    configure :production do
      def javascript_include_merged( group )
        javascript_include_tag([ group, 'packaged'].join('_'))
      end

      def stylesheet_link_merged( group )
        stylesheet_link_tag([ group, 'packaged' ].join('_'))
      end
    end

    private
      def stylesheet_link_tag( stylesheet )
        sprintf(
          '<link href="%s.css" type="text/css" rel="stylesheet" />',
          [app_config(:asset_host), 'stylesheets', stylesheet].join('/')
        )
      end

      def javascript_include_tag( javascript )
        sprintf(
          '<script src="%s.js" type="text/javascript"></script>',
          [app_config(:asset_host), 'javascripts', javascript].join('/')
        )
      end

      def asset_packages_config
        YAML.load_file(root_path('config', 'asset_packages.yml'))    
      end
  end
end
