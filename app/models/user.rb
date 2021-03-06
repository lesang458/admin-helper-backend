class User < ApplicationRecord
  has_many :day_off_infos, dependent: :destroy
  accepts_nested_attributes_for :day_off_infos
  has_many :day_off_requests, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :device_histories, dependent: :destroy
  DEFAULTPASSWORD = '123456'.freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  RESET_TOKEN_LIFESPAN = 15.minutes
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validate :validate_roles_inclusion
  validates :first_name, presence: true, length: { in: 2..20 }
  validates :last_name, presence: true, length: { in: 2..20 }
  enum status: { ACTIVE: 'ACTIVE', FORMER: 'FORMER' }
  validates :status, presence: true, inclusion: { in: %w[ACTIVE FORMER] }
  enum certificate: { UNIVERSITY: "UNIVERSITY", COLLEGE: "COLLEGE", INTERMEDIATE: "INTERMEDIATE", MASTER: "MASTER" }
  validates :certificate, presence: true, inclusion: { in: %w[UNIVERSITY COLLEGE INTERMEDIATE MASTER] }
  enum position: { INTERN: "INTERN", FRESHER: "FRESHER", JUNIOR_DEV: "JUNIOR_DEV", SENIOR_DEV: "SENIOR_DEV", JUNIOR_BA: "JUNIOR_BA", SENIOR_BA: "SENIOR_BA", JUNIOR_QA: "JUNIOR_QA", SENIOR_QA: "SENIOR_QA", HR: "HR", PM: "PM" }
  validates :position, presence: true, inclusion: { in: %w[INTERN FRESHER JUNIOR_DEV SENIOR_DEV JUNIOR_BA SENIOR_BA JUNIOR_QA SENIOR_QA HR PM]}
  VALID_PHONE_NUMBER_REGEX = /\d[0-9]\)*\z/.freeze
  validates :phone_number, presence: true, allow_nil: true, length: { maximum: 25 },
                           format: { with: VALID_PHONE_NUMBER_REGEX }
  ALLOWED_ROLES = %w[SUPER_ADMIN ADMIN EMPLOYEE].freeze

  scope :employees, -> { where('roles @> ?', '{EMPLOYEE}}') }
  scope :admins, -> { where('roles @> ?', '{ADMIN}') }
  scope :super_admins, -> { where('roles @> ?', '{SUPER_ADMIN}') }

  PASSWORD_FORMAT = /\A(?!.*\s)/x.freeze
  attr_accessor :password

  validates :password, presence: true, length: { in: 6..40 }, format: { with: PASSWORD_FORMAT }, on: %i[create account_setup]
  before_create :encrypt_password
  scope :employee_name_like, ->(employee_name) { where('first_name ILIKE ? OR last_name ILIKE ?', "%#{employee_name}%", "%#{employee_name}%") if employee_name }

  def admin?
    roles.include?('ADMIN')
  end

  def request_day_off(params, user_id)
    raise(ExceptionHandler::Forbidden, 'You do not have permission') if !admin? && id != user_id.to_i
    employee = User.find(user_id)
    day_off_request = employee.day_off_requests.new(params)
    day_off_request.status = admin? ? 'approved' : 'pending'
    day_off_request.save!
    send_mail(day_off_request)
    day_off_request.separate_request
  end

  def send_mail(day_off_request)
    admin? ? UserMailer.notify_requested_employee(day_off_request, 'Approved Request').deliver_now : UserMailer.notify_admins(day_off_request, 'Created Request').deliver_now
  end

  def update_password(password_params)
    raise(ArgumentError, 'Your password was incorrect.') unless check_valid_password(password_params[:old_password])
    self.password = password_params[:new_password]
    raise(ArgumentError, self.errors.messages) unless self.valid?(:account_setup)
    encrypt_password
    save!
  end

  def encrypt_password
    self.encrypted_password = User.generate_encrypted_password(password)
  end

  def generate_password_token
    self.reset_password_token = SecureRandom.rand(100_000..999_999)
    self.reset_password_sent_at = Time.now
    save!
  end

  def send_mail_notification_canncel
    UserMailer.password_reset(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_token_valid?(token)
    reset_password_token == token && password_reset_not_expired?
  end

  def password_reset_not_expired?
    Time.now < (reset_password_sent_at + RESET_TOKEN_LIFESPAN).localtime
  end

  def self.build_employee(create_params)
    user = User.new(create_params)
    user.roles << 'EMPLOYEE'
    user
  end

  def approved_requests_in_month(month)
    beginning_of_month = month.beginning_of_month
    end_of_month = month.end_of_month
    query = "(status = 'approved' or status = 'pending') and ((from_date <= ? and to_date >= ?) or (from_date >= ? and to_date <= ?) or (from_date <= ? and to_date >= ?))"
    day_off_requests.where(query, beginning_of_month, beginning_of_month, beginning_of_month, end_of_month, end_of_month, end_of_month)
  end

  def total_days_off(month, has_salary)
    beginning_of_month = month.beginning_of_month
    end_of_month = month.end_of_month
    approved_requests_in_month(month).select { |it| it.day_off_category.present? == has_salary }.sum do |it|
      first = it.from_date > beginning_of_month ? it.from_date : beginning_of_month
      last = it.to_date < end_of_month ? it.to_date : end_of_month
      business_days_between(first.to_date, last.to_date) * it.hours_per_day / 8
    end
  end

  def business_days_between(date1, date2)
    business_days = 0
    date = date2
    while date >= date1
     business_days = business_days + 1 unless date.saturday? or date.sunday?
     date = date - 1.day
    end
    business_days
  end


  def total_paid_days_off(month)
    total_days_off(month, true)
  end

  def total_non_paid_days_off(month)
    total_days_off(month, false)
  end

  def update_infos(infos_params)
    infos_params.each do |day_off_info|
      day_off = day_off_infos.find_or_create_by day_off_category_id: day_off_info[:day_off_category_id]
      day_off.update!(hours: day_off_info[:hours], status: day_off_info[:status])
    end
  end

  def validate_roles_inclusion
    errors.add(:record, 'roles have to include [EMPLOYEE ADMIN SUPER_ADMIN]') if roles.any? { |it| ALLOWED_ROLES.exclude?(it) }
  end

  def self.generate_encrypted_password(password, password_salt = BCrypt::Engine.generate_salt)
    BCrypt::Engine.hash_secret(password, password_salt)
  end

  def check_valid_password(password)
    encrypted_password == User.generate_encrypted_password(password, encrypted_password.first(29))
  end

  def jwt_payload
    {
      user_id: id,
      roles: roles
    }
  end

  scope :birthday_to, ->(to) { where('birthdate <= ?', to) if to }
  scope :birthday_from, ->(from) { where('birthdate >= ?', from) if from }
  scope :join_date_to, ->(to) { where('join_date <= ?', to) if to }
  scope :join_date_from, ->(from) { where('join_date >= ?', from) if from }
  scope :day_off_request_to, ->(to) { where('day_off_requests.from_date <= ? OR day_off_requests.to_date <= ?', to, to) if to }
  scope :day_off_request_from, ->(from) { where('day_off_requests.from_date >= ? OR day_off_requests.to_date >= ?', from, from) if from }
  validate :birthday_in_future
  def birthday_in_future
    errors.add(:birthdate, 'is in future') if birthdate.present? && birthdate > Time.zone.now
  end

  # rubocop:disable Metrics/AbcSize
  def self.search(params)
    users = User.eager_load(day_off_infos: %I[day_off_category day_off_requests])
    if params[:day_off_to_date] || params[:day_off_from_date]
      users = User.joins(:day_off_requests).day_off_request_to(params[:day_off_to_date]).day_off_request_from(params[:day_off_from_date]).group('id')
    end
    users = users.where('first_name ILIKE :search OR last_name ILIKE :search OR phone_number ILIKE :search', search: "%#{params[:search]}%") if params[:search].present?
    users = users.where('users.status = :search', search: params[:status]) if params[:status]
    users = users.birthday_to(params[:birthday_to])
    users = users.birthday_from(params[:birthday_from])
    users = users.join_date_to(params[:joined_company_date_to])
    users.join_date_from(params[:joined_company_date_from])
  end
  # rubocop:enable Metrics/AbcSize
end
