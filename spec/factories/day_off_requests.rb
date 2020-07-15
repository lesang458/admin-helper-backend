FactoryBot.define do
  factory :day_off_request do
    day_off_info { DayOffInfo.first }
    hours_per_day { 12 }
    from_date { '2020-07-10' }
    to_date { '2020-07-20' }
  end
end
