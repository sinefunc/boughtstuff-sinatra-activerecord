class Main
  helpers do
    def cached_file_id( uploader )
      uploader.file.path.gsub(uploader.cache_dir + '/', '')
    end
  end

  post '/uploader' do
    uploader = PhotoUploader.new
    
    begin
      if params[:item][:photo_url].present?
        uploader.cache!( StreamedFile.new(params[:item][:photo_url]) )
      else
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
