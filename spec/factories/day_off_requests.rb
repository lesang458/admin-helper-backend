FactoryBot.define do
  factory :day_off_request do
    day_off_info
    hours_per_day { 8 }
    from_date { '2020-07-08' }
    to_date { '2020-07-30' }
    user
  end
end
