class Main
  helpers do
    def image_tag( path, options = {} )
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

    def stylesheet_link_merged( group )
      asset_packages_config['stylesheets'].first[group.to_s].map do |file|
        %(<link href="#{app_config(:asset_host)}/stylesheets/#{file}.css" 
                type="text/css" rel="stylesheet" />)
      end.join("\n")
    end

    def javascript_include_merged( group )
      asset_packages_config['javascripts'].first[group.to_s].map do |file|
        %(<script src="#{app_config(:asset_host)}/javascripts/#{file}.js" 
                  type="text/javascript"></script>)
      end.join("\n")
    end

    private
      def asset_packages_config
        YAML.load_file(root_path('config', 'asset_packages.yml'))    
      end
  end
end
