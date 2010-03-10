module Gen 
  class Migration < Thor::Group
    include Thor::Actions
    
    argument :name
    
    def self.source_root
      File.dirname(__FILE__)
    end

    def create_the_migration
      template('templates/migration.tt', "db/migrate/#{timestamp}_#{filename}")
    end
     
    private
      def camelized_name
        name.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }  
      end

      def filename
        "#{name}.rb"
      end

      def timestamp
        Time.now.utc.strftime('%Y%m%d%H%M%S')
      end
  end
end

