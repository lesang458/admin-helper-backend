FactoryBot.define do
  factory :day_off_category do
    trait :day_off_category_vacation do
      name { 'VACATION' }
    end
    trait :day_off_category_illness do
      name { 'ILLNESS' }
    end
  end
end
