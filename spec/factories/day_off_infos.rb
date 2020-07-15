FactoryBot.define do
  factory :day_off_info do
    user { User.first }
    hours { 12 }
    trait :vacation do
      day_off_category_id { (DayOffCategory.find_by name: 'VACATION').id }
    end
    trait :illness do
      day_off_category_id { (DayOffCategory.find_by name: 'ILLNESS').id }
    end
  end
end
