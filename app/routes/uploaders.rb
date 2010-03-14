class Main
  helpers do
    def cached_file_id( uploader )
      uploader.file.path.gsub(uploader.cache_dir + '/', '')
    end

    def generate_unique_filename( filename )
      [ UUID.sha1, File.extname(filename).downcase ].join
    end

    def assert_valid_cache_id!( cache_id )
      unless cache_id.match(Format::CARRIER_WAVE_CACHE_ID)
        raise "Not a valid cache id #{cache_id}" 
      end
    end

    def assert_valid_filename!( filename )
      unless filename.match(Format::CARRIER_WAVE_FILENAME)
        raise "Not a valid filename #{filename}" 
      end
    end
  end
  
  get  '/tmp/uploads/:cache_id/:filename' do |cache_id, filename|
    assert_valid_cache_id!( cache_id )
    assert_valid_filename!( filename )
  

    send_file root_path("tmp", "uploads", cache_id, filename), 
      :disposition => 'inline' 
  end

  post '/uploader' do
    content_type 'text/json'
    
    logger.debug "-----> Receiving upload in /uploader"

    uploader = PhotoUploader.new
    
    begin
      if params[:item][:photo_url].present?
        logger.debug "-----> Photo URL given (#{params[:item][:photo_url]})"
        uploader.cache!( StreamedFile.new(params[:item][:photo_url]) )
      else
        logger.debug "-----> Photo file given (#{params[:item][:photo][:filename]})"
        params[:item][:photo][:filename] = 
          generate_unique_filename( params[:item][:photo][:filename] )

        uploader.cache!(params[:item][:photo])
      end
    rescue CarrierWave::IntegrityError, CarrierWave::ProcessingError
      logger.debug " ! Got an error while processing"
      { errors: 'processing error' }.to_json
    else
      data = { 
        thumb:      uploader.thumb.url,
        original:   uploader.large.url,
        filename:   cached_file_id(uploader),
        title:      sprintf('%.15s...', uploader.filename),
      }

      logger.debug "-----> Returning response: #{data.inspect}"

      data.to_json
    end
  end
end
