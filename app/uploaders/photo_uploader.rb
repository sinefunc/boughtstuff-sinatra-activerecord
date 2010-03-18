class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  
  settings(:photos).each do |key, value|
    send key, String === value ? value.gsub(':root', root_path) : value
  end

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
    "photos/#{version_name}/missing.jpg"
  end

  def url( *args )
    ret = super(*args) 
    ret.gsub(root_path, '')
  end
end
