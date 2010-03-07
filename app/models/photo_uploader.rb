class PhotoUploader < CarrierWave::Uploader::Base
  storage :file

  include CarrierWave::ImageScience

  version :large do
    process :resize_to_fit  => [ 640, 480 ]
  end

  version :thumb do
    process :resize_to_fill => [ 160, 195 ]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
