class GalleryPhoto
  include Mongoid::Document

  field :src, type: String
  field :root, type: Boolean

  embedded_in :gallery
  mount_uploader :src, PhotosUploader

end
