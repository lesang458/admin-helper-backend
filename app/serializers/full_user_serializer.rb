class FullUserSerializer < ActiveModel::Serializer
  has_many :day_off_infos
  attributes :id, :email, :first_name, :last_name, :day_off_infos, :birthdate, :join_date, :status, :phone_number, :roles, :total_paid_days_off, :total_non_paid_days_off, :salary_per_month, :certificate, :position
  class DayOffInfoSerializer < ActiveModel::Serializer
    attributes :day_off_category_id, :hours, :category_name, :available_hours, :status
  end

  def total_paid_days_off
    object.total_paid_days_off(month) if month
  end

  def total_non_paid_days_off
    object.total_non_paid_days_off(month) if month
  end

  def month
    instance_options.dig(:serializer_params, :month)
  end
end
