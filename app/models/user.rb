class User < ApplicationRecord
  DEFAULTPASSWORD = '123456'.freeze
  has_one :employee, dependent: :destroy
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  delegate :first_name, :last_name, :birthday, :joined_company_date, :status, :phone_number, to: :employee

  def self.generate_encrypted_password(password, password_salt = BCrypt::Engine.generate_salt)
    BCrypt::Engine.hash_secret(password, password_salt)
  end

  def check_valid_password(password)
    encrypted_password == User.generate_encrypted_password(password, encrypted_password.first(29))
  end

  def render_payload
    { 'user_id' => id }
  end
end
