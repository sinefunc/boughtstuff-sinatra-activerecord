ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

load 'vendor/asset_packager/lib/tasks/asset_packager_tasks.rake'

namespace :assets do
  namespace :upload do
    desc "Upload all assets to assets.boughtstuff.com"
    task :s3 => :environment do
      config = YAML.load_file('config/settings.yml')[RACK_ENV.to_sym][:photos]

      files = [ "public/stylesheets/*_packaged.css",
        "public/javascripts/*_packaged.js",
        "public/images/**/*",
        "public/photos/**/*"
      ].map { |glob| Dir[glob] }.flatten

      AWS::S3::Base.establish_connection!(
        :access_key_id => config[:s3_access_key_id],
        :secret_access_key => config[:s3_secret_access_key]
      )

      bucket = AWS::S3::Bucket.find(config[:s3_bucket])

      files.each do |f|
        next if File.directory?(f)
        key = f.gsub(/public\//, '')
        puts "putting #{f} into S3 as #{key}"

        AWS::S3::S3Object.store(
          key, open(f), config[:s3_bucket], :access => :public_read
        )
      end

      puts "done. #{files.size} files uploaded"
    end
  end
end
