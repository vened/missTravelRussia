require 'autoinc'
require 'csv'
class User
  include Mongoid::Document
  include Mongoid::Enum
  include Mongoid::Timestamps
  include Mongoid::Autoinc


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :vkontakte]


  # fields
  field :role, type: Integer

  field :number, type: Integer

  field :is_vote, type: Boolean, default: false # флаг обозначающий что пользователь участвует в конкурсе, заменяем на роль, отрефакторить везде
  field :is_bot, type: Boolean, default: false
  field :is_disqualify, type: Boolean
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

  index({votes: -1, created_at: 1, role: 1, uid: 1, is_vote: 1})
  index({number: 1}, {unique: true})

  embeds_many :user_voteables
  index "user_voteables.user_voteable_id" => 1
  embeds_many :photos, cascade_callbacks: true
  index "photos.root" => 1


  # contestant - участник конкурса
  enum :role, [:contestant, :user, :admin]


  after_initialize :set_default_role, :if => :new_record?

  increments :number

  def set_default_role
    self.role ||= :user
  end

  def self.from_omniauth(auth)
    current_user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email.present? ? auth.info.email : "#{auth.uid}@#{auth.provider}.com"
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.image = auth.info.image
    end

    if auth.provider === 'facebook'
      profile = auth.extra.raw_info.link
      gender = auth.extra.raw_info.gender
      bdate = auth.info.birthday
      location = auth.extra.raw_info.location.present? && auth.extra.raw_info.location.name
    end
    if auth.provider === 'vkontakte'
      profile = auth.info.urls.Vkontakte
      location = auth.info.location
      bdate = auth.extra.raw_info.bdate
      gender = auth.extra.raw_info.sex == 2 ? 'male' : 'female'
    end

    current_user.update(
        profile: profile.present? ? profile : nil,
        gender: gender.present? ? gender : nil,
        location: location.present? ? location : nil,
        bdate: bdate.present? ? bdate : nil,
        role: :contestant # регистрация участника
    # is_vote: gender == 'male' ? false : true
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

end
