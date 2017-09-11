class Photo
  include Mongoid::Document

  field :photo_src, type: String
  field :root, type: Boolean

  embedded_in :user
  mount_uploader :photo_src, PhotosUploader

end
