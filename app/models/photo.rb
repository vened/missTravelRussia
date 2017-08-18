class Photo
  include Mongoid::Document

  field :photo_src, type: String

  embedded_in :user
  mount_uploader :photo_src, PhotosUploader

end
