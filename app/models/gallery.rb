class Gallery
  include Mongoid::Document

  field :title, type: String
  field :description, type: String
  field :title_seo, type: String
  field :description_seo, type: String
  field :show_home, type: Boolean
  field :show_menu, type: Boolean

  embeds_many :gallery_photos, cascade_callbacks: true

  accepts_nested_attributes_for :gallery_photos

  # Method
  def create_associated_image(image)
    gallery_photos.create(src: image)
  end
end
