class User < ApplicationRecord
  has_many :question_answers, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  def self.search(search)
    return User.all unless search
    User.where(['name LIKE ?', "%#{search}%"])
  end
  validates :check, presence: true

  def update_without_current_password(params)
    params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    clean_up_passwords
    update_attributes(params)
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth['provider'].to_s || uid != omniauth['uid']
    credentials = omniauth['credentials']
    info = omniauth['info']

    access_token = credentials['refresh_token']
    access_secret = credentials['secret']
    credentials = credentials.to_json
    name = info['name']
    # self.set_values_by_raw_info(omniauth['extra']['raw_info'])
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end
end
