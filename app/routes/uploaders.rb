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
    uploader = PhotoUploader.new
    
    begin
      if params[:item][:photo_url].present?
        uploader.cache!( StreamedFile.new(params[:item][:photo_url]) )
      else
        params[:item][:photo][:filename] = 
          generate_unique_filename( params[:item][:photo][:filename] )

        uploader.cache!(params[:item][:photo])
      end
    rescue CarrierWave::IntegrityError, CarrierWave::ProcessingError
      { errors: 'processing error' }.to_json
    else
      { thumb:      uploader.thumb.url,
        original:   uploader.large.url,
        filename:   cached_file_id(uploader),
        title:      sprintf('%.15s...', uploader.filename),
      }.to_json
    end
  end
end
