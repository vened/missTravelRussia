# encoding: utf-8

class PhotosUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer

  storage :file
  process optimize: [{quality: 80}]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process :resize_to_limit => [350, 350]
  end

  version :large do
    process :resize_to_limit => [1600, 1600]
  end
end
