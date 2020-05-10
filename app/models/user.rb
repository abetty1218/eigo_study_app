class User < ApplicationRecord
   has_many :question_answers, dependent: :destroy
   before_save   :downcase_email
   before_save { self.email = email.downcase }
   validates :name, presence: true, length: { maximum: 50 }
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
   validates :email, presence:   true, length: { maximum: 255 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
   has_secure_password
   validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
   validates :check, presence: true


   # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

   # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end


  def self.updatable_attributes
    ["name", "email","password","admin","superior"]
  end

  def self.search(search)
    return User.all unless search
    User.where(['name LIKE ?', "%#{search}%"])
  end

  private
  # メールアドレスをべて小文字にする
    def downcase_email
      self.email = email.downcase
    end
end
