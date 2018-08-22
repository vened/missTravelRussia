class Post
  include Mongoid::Document
  include Mongoid::Enum
  include Mongoid::Timestamps


  field :title, type: String
  field :description, type: String
  field :title_seo, type: String
  field :description_seo, type: String
  field :img, type: String
  field :date, type: DateTime

  validates :title, presence: true
  validates :description, presence: true
  validates :title_seo, length: { in: 4..80 }
  validates :description_seo, length: { in: 10..200 }

  mount_uploader :img, PhotosUploader
  paginates_per 10

end
