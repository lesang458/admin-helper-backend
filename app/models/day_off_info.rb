class DayOffInfo < ApplicationRecord
  belongs_to :user
  has_many :day_off_requests
  belongs_to :day_off_category
  validates :hours, presence: true, numericality: { only_integer: true, greater_than: 0 }
  delegate :email, :first_name, :last_name, to: :user
  delegate :category_name, :description, to: :day_off_category

  def available_hours
    hours - total_hours_of_request
  end

  def total_hours_of_request
    day_off_requests.sum(&:total_hours_off)
  end

  def self.create_day_off_info(day_off_infos, user)
    day_off_infos.each do |day_off|
      DayOffCategory.find(day_off['day_off_category_id'])
      user.day_off_infos.create! day_off_category_id: day_off['day_off_category_id'], hours: day_off['hours']
    end
  end

  def self.update_day_off_info(day_off_infos, user)
    raise(ExceptionHandler::BadRequest, 'Input day_off_info_id seem not belong to user') unless DayOffInfo.valid_day_off_id?(day_off_infos, user)
    day_off_infos.each do |day_off|
      day_off_info = DayOffInfo.find(day_off['day_off_info_id'])
      DayOffCategory.find(day_off['day_off_category_id'])
      day_off_info.update!(day_off_category_id: day_off['day_off_category_id']) if day_off['day_off_category_id']
      day_off_info.update!(hours: day_off['hours']) if day_off['hours']
    end
    DayOffInfo.many_overlapping_category?(user)
  end

  def self.valid_day_off_id?(day_off_infos, user)
    day_off_ids = day_off_infos.collect { |day_off| day_off['day_off_info_id'].to_i }
    raise(ExceptionHandler::BadRequest, 'day_off_infos cannot have the same day_off_category_id') if day_off_ids.size > 1 && day_off_ids.uniq.size == 1
    ids = user.day_off_infos.select('id').to_a.collect(&:id)
    day_off_ids.all? { |id| ids.include?(id) }
  end

  def self.many_overlapping_category?(user)
    ids = user.day_off_infos.select('day_off_category_id').to_a.collect(&:day_off_category_id)
    raise(ExceptionHandler::BadRequest, 'User has many overlapping day_off_category') if ids.size > 1 && ids.uniq.size == 1
  end

  def category_name
    day_off_category.name
  end

  def self.search(params)
    day_off_infos = DayOffInfo.all
    day_off_infos = day_off_infos.where('user_id = ?', params[:user_id]) if params[:user_id].present?
    day_off_infos = day_off_infos.where('day_off_category_id = ?', params[:day_off_category_id]) if params[:day_off_category_id].present?
    day_off_infos
  end
end
