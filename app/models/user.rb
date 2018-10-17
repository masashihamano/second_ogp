class User < ApplicationRecord

# email属性を小文字に変換
  before_save { self.email = email.downcase }

# メールアドレスの正規表現
# uniqueness: trueは文字の大小を区別
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
