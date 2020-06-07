class User < ApplicationRecord
  has_one :employee, dependent: :destroy
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  def first_name
    employee.first_name
  end

  def last_name
    employee.last_name
  end

  def birthday
    employee.birthday
  end

  def joined_company_date
    employee.joined_company_date
  end

  def status
    employee.status
  end

  def phone_number
    employee.phone_number
  end

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
