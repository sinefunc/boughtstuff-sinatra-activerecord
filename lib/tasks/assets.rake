namespace :assets do
  task :package do
    require 'yaml'

    config = YAML.load_file('config/asset_packages.yml')
 
    puts  "-----> Initializing asset packaging"
    puts  "-----> Packaging javascripts..."
  
    config['javascripts'].first.each do |group, files|
      print "       Concatenating #{group}... "
      File.open("/tmp/#{group}_packaged.js", 'w') do |f|
        files.each do |file|
          f.write File.read("public/javascripts/#{file}.js")
          f.write ';'
        end
      end
      puts  "Done!"
    end
  

    puts  "-----> Packaging stylesheets..."
    config['stylesheets'].first.each do |group, files|
      print "       Concatenating #{group}... "
      File.open("/tmp/#{group}_packaged.css", 'w') do |f|
        files.each do |file|
          f.write File.read("public/stylesheets/#{file}.css")
        end
      end
      puts  "Done!"
    end
    

    print "       Compressing javascripts... "
    `ruby bin/jsmin.rb < /tmp/base_packaged.js > public/javascripts/base_packaged.js`
    puts  "Done!"

    print "       Compressing stylesheets... "
    `ruby bin/jsmin.rb < /tmp/base_packaged.css > public/stylesheets/base_packaged.css`
    puts  "Done!"
  end

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
