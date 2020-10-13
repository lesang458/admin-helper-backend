class DayOffCategory < ApplicationRecord
  validates :name, uniqueness: true
  has_many :day_off_infos, dependent: :destroy
  has_many :day_off_requests, through: :day_off_infos
  enum status: { active: 'ACTIVE', inactive: 'INACTIVE' }
  validates :status, presence: true, inclusion: { in: %w[active inactive] }
  validates :name, presence: true, length: { in: 2..40 }
  validates :description, allow_nil: true, length: { minimum: 3 }
  validates :total_hours_default, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.search(params)
    DayOffCategory.where({ status: params[:status].presence }.compact)
  end

  def build_day_off_infos(day_off_infos_params)
    employee_ids = day_off_infos_params[:apply_for_all_employees].present? ? User.all.pluck(:id) : day_off_infos_params[:employee_ids]
    return unless employee_ids.present?
    employee_ids.each do |employee_id|
      employee = User.find employee_id
      employee.day_off_infos.create! hours: 0, day_off_category_id: id
    end
  end
end
