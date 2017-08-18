class Page
  include Mongoid::Document
  include Mongoid::Enum

  field :title, type: String
  field :description, type: String

end
