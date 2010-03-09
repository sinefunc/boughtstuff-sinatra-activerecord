class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::ImageScience

  storage :file
  
  version :large do
    process :resize_to_limit => [640, 480]
  end

  version :thumb do
    process :resize_to_fill => [160,195]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def default_url
    "/photos/#{version_name}/missing.jpg"
  end
end
