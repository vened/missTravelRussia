class Order
  include Mongoid::Document

  field :last_name, type: String
  field :name, type: String
  field :last_name_zagran, type: String
  field :name_zagran, type: String
  field :birth_date, type: String
  field :passport_number, type: String
  field :passport_expire, type: String
  field :phone, type: String
  field :email, type: String
  field :company, type: String
  field :position, type: String
  field :visa, type: String
  field :transfer_1, type: String
  field :transfer_2, type: String
  field :comments, type: String
  field :personal_confirm, type: String

  validates :last_name, presence: true
end
