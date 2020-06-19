class User < ApplicationRecord
  DEFAULTPASSWORD = '123456'.freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: { in: 2..20 }
  validates :last_name, presence: true, length: { in: 2..20 }
  enum status: { ACTIVE: 'ACTIVE', FORMER: 'FORMER' }
  validates :status, presence: true, inclusion: { in: %w[ACTIVE FORMER] }
  VALID_PHONE_NUMBER_REGEX = /\d[0-9]\)*\z/.freeze
  validates :phone_number, presence: true, allow_nil: true, length: { maximum: 25 },
                           format: { with: VALID_PHONE_NUMBER_REGEX }

  def self.generate_encrypted_password(password, password_salt = BCrypt::Engine.generate_salt)
    BCrypt::Engine.hash_secret(password, password_salt)
  end

  def check_valid_password(password)
    encrypted_password == User.generate_encrypted_password(password, encrypted_password.first(29))
  end

  def render_payload
    { 'user_id' => id }
  end

  scope :birthday_to, ->(to) { where('birthdate <= ?', to) if to }
  scope :birthday_from, ->(from) { where('birthdate >= ?', from) if from }
  scope :join_date_to, ->(to) { where('join_date <= ?', to) if to }
  scope :join_date_from, ->(from) { where('join_date >= ?', from) if from }
  validate :birthday_in_future
  def birthday_in_future
    errors.add(:birthdate, 'is in future') if birthdate.present? && birthdate > Time.zone.now
  end

  # rubocop:disable Metrics/AbcSize
  def self.search(params)
    users = User.all
    users = users.where('first_name ILIKE :search OR last_name ILIKE :search OR phone_number ILIKE :search', search: "%#{params[:search]}%") if params[:search].present?
    users = users.where('status = :search', search: params[:status]) if params[:status]
    users = users.birthday_to(params[:birthday_to])
    users = users.birthday_from(params[:birthday_from])
    users = users.join_date_to(params[:joined_company_date_to])
    users = users.join_date_from(params[:joined_company_date_from])
    users
  end
  # rubocop:enable Metrics/AbcSize
end
