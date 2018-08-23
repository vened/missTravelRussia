require 'autoinc'
require 'csv'
class User
  include Mongoid::Document
  include Mongoid::Enum
  include Mongoid::Timestamps
  include Mongoid::Autoinc


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable, :recoverable,
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :vkontakte]


  # fields
  field :role, type: Integer

  field :number, type: Integer

  field :is_vote, type: Boolean, default: false # флаг обозначающий что пользователь участвует в конкурсе, заменяем на роль, отрефакторить везде
  field :is_bot, type: Boolean, default: false
  field :is_disqualify, type: Boolean, default: false
  field :votes, type: Integer, default: 0
  field :rating, type: Integer

  ## Database authenticatable
  field :email, type: String, default: ""
  field :email2, type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time
  field :remember_created_at, type: Time
  field :sign_in_count, type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at, type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip, type: String

  field :name, type: String
  field :about, type: String
  field :image, type: String
  field :organization, type: String
  field :organization_site, type: String
  field :position, type: String
  field :work_experience, type: String
  field :age, type: String
  field :phone, type: String
  field :gender, type: String
  field :bdate, type: String
  field :location, type: String

  ## Oauth
  field :provider, type: String
  field :uid, type: String
  field :profile, type: String
  field :raw_info, type: Object

  index({votes: -1, created_at: 1, role: 1, uid: 1, is_vote: 1})
  index({_role: 1, photos: 1, votes: 1})
  index({_role: 1, photos: 1, is_disqualify: 1, votes: 1})
  index({number: 1}, {unique: true})

  embeds_many :user_voteables
  index "user_voteables.user_voteable_id" => 1
  embeds_many :photos, cascade_callbacks: true
  index "photos.root" => 1

  accepts_nested_attributes_for :user_voteables
  accepts_nested_attributes_for :photos

  # contestant - участник конкурса
  enum :role, [:contestant, :user, :admin]


  after_initialize :set_default_role, :if => :new_record?

  increments :number

  def set_default_role
    self.role ||= :user
  end

  def self.from_omniauth(auth)

    if auth.provider === 'facebook'
      new_raw_info  = auth.extra.raw_info
      new_profile  = auth.extra.raw_info.link
      new_gender   = auth.extra.raw_info.gender
      new_bdate    = auth.info.birthday
      new_location = auth.extra.raw_info.location.present? && auth.extra.raw_info.location.name
    end
    if auth.provider === 'vkontakte'
      new_raw_info  = {}
      new_profile  = auth.info.urls.Vkontakte
      new_location = auth.info.location
      new_bdate    = auth.extra.raw_info.bdate
      new_gender   = auth.extra.raw_info.sex == 2 ? 'male' : 'female'
    end


    current_user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email    = auth.info.email.present? ? auth.info.email : "#{auth.uid}@#{auth.provider}.com"
      user.password = Devise.friendly_token[0, 20]
      user.name     = auth.info.name
      user.image    = auth.info.image
      if (REGISTRATION_END_DATE - Date.current).to_i > 0 && new_gender == 'female'
        user.role = :contestant
      else
        user.role = :user
      end
    end

    if current_user.profile.blank?
      profile = new_profile.present? ? new_profile : nil
    else
      profile = current_user.profile
    end

    if current_user.gender.blank?
      gender = new_gender.present? ? new_gender : nil
    else
      gender = current_user.gender
    end

    if current_user.location.blank?
      location = new_location.present? ? new_location : nil
    else
      location = current_user.location
    end

    if current_user.bdate.blank?
      bdate = new_bdate.present? ? new_bdate : nil
    else
      bdate = current_user.bdate
    end

    current_user.update(
        raw_info: new_raw_info,
        profile:  profile,
        gender:   gender,
        location: location,
        bdate:    bdate,
    )

    return current_user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  before_update :build_organization_site

  def build_organization_site
    if self.organization_site.present?
      self.organization_site = self.organization_site.gsub(/https|http/, '')
      self.organization_site = self.organization_site.gsub(/\:*/, '')
      self.organization_site = self.organization_site.gsub(/\/*/, '')
    end
  end

  validates :organization, presence: true, on: :update
  validates :work_experience, presence: true, on: :update
  validates :position, presence: true, on: :update
  validates :name, presence: true, on: :update
  validates :age, presence: true, on: :update
  validates :location, presence: true, on: :update
  validates :organization_site, presence: true, on: :update
  validates :email2, presence: true, on: :update
  validates :phone, presence: true, on: :update

  paginates_per 12

  def to_param
    number.to_s
  end

  def self.to_csv(options = {})
    field :name, type: String
    field :about, type: String
    field :image, type: String
    field :organization, type: String
    field :organization_site, type: String
    field :position, type: String
    field :work_experience, type: String
    field :age, type: String
    field :phone, type: String
    field :gender, type: String
    field :bdate, type: String
    field :location, type: String

    ## Oauth
    field :provider, type: String
    field :uid, type: String
    field :profile, type: String

    column_names = [
        "имя",
        "email",
        "голосов",
        'about',
        'organization',
        'organization_site',
        'position',
        'work_experience',
        'age',
        'phone',
        'location',
    ]
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |user|
        csv << [
            user.name,
            user.email,
            user.votes,
            user.about,
            user.organization,
            user.organization_site,
            user.position,
            user.work_experience,
            user.age,
            user.phone,
            user.location,
        ]
      end
    end
  end

  def user_email
    "#{self.name}, #{self.organization}, #{self.age}"
  end

  scope :contestants, -> { User.where(_role: 'contestant') }
  scope 'участницы', -> { contestants.where(photos: {'$elemMatch': {root: true}}) }
  scope 'все участницы', -> { contestants }
  scope 'голосующие', -> { User.where(_role: 'user') }
  scope 'админы', -> { User.where(_role: 'admin') }

  rails_admin do
    list do
      scopes ['участницы', 'все участницы', 'голосующие', 'админы']

      field :number do
        label 'id'
        column_width 40
      end
      field :role do
        column_width 80
      end
      field :name do
        label 'Имя'
        column_width 160
      end
      field :age do
        column_width 50
      end
      field :gender do
        label 'Пол'
        column_width 50
      end
      field :phone do
        column_width 120
      end
      field :email2 do
        column_width 120
      end
      field :organization do
        label 'Компания'
        column_width 150
      end
      field :created_at do
        column_width 120
      end
      field :updated_at do
        column_width 120
      end
      field :email do
        column_width 120
      end
      field :is_disqualify
    end
    edit do
      field :name
      field :about
      field :age
      field :role, :enum do
        enum do
          [:contestant, :user, :admin]
        end
      end
      field :gender, :enum do
        enum do
          [:male, :female]
        end
      end
      field :email2
      field :phone
      field :organization
      field :organization_site
      field :work_experience
      field :position
      field :location
      field :is_disqualify
    end
  end

end
