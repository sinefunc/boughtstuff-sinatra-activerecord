class Main
  helpers do
    def image_tag( path, options = {} )
      raise ArgumentError, "no path given" unless path

      src = 
        if path.index('/') == 0
          asset_host_join( path )
          # [ app_config(:asset_host), path ].join
        elsif path.index('http') == 0
          path
        else
          asset_host_join( assets_path_prefix, 'images', path )
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
    
    def assets_path_prefix
      begin
        File.read(root_path('config', 'deployed_at')).strip
      rescue
        nil
      end
    end

    def asset_host_with_prefix
      [ Array(app_config(:asset_host)).first, assets_path_prefix ].compact.join('/')
    end

    private
      def stylesheet_link_tag( stylesheet )
        mtime = File.mtime(root_path('public', 'stylesheets', "#{stylesheet}.css"))

        sprintf(
          '<link href="%s.css?%s" type="text/css" rel="stylesheet" />',
          asset_host_join( assets_path_prefix, 'stylesheets', stylesheet ),
          mtime.to_i
        )
      end

      def javascript_include_tag( javascript )
        mtime = File.mtime(root_path('public', 'javascripts', "#{javascript}.js"))

        sprintf(
          '<script src="%s.js?%s" type="text/javascript"></script>',
          asset_host_join( assets_path_prefix, 'javascripts', javascript ),
          mtime.to_i
        )
      end

      def asset_packages_config
        YAML.load_file(root_path('config', 'asset_packages.yml'))    
      end

      def asset_host_join(*args)
        filename = File.join(*(args.compact))
      
        asset_host = 
          if app_config(:asset_host).is_a?(Array)
            app_config(:asset_host)[filename.hash.abs % app_config(:asset_host).size]
          else
            app_config(:asset_host)
          end

        File.join(asset_host, filename)
      end
  end
end
