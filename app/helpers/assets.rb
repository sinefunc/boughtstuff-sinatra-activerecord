class Main
  helpers do
    def stylesheet_link_merged( group )
      asset_packages_config['stylesheets'].first[group.to_s].map do |file|
        %(<link href="#{Boughtstuff::ASSET_HOST}/stylesheets/#{file}.css" 
                type="text/css" rel="stylesheet" />)
      end.join("\n")
    end

    def javascript_include_merged( group )
      asset_packages_config['javascripts'].first[group.to_s].map do |file|
        %(<script src="#{Boughtstuff::ASSET_HOST}/javascripts/#{file}.js" 
                  type="text/javascript"></script>)
      end.join("\n")
    end

    private
      def asset_packages_config
        YAML.load_file(root_path('config', 'asset_packages.yml'))    
      end
  end
end
