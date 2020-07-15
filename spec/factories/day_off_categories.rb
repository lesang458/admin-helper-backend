FactoryBot.define do
  factory :day_off_category do
    trait :vacation do
      name { 'VACATION' }
    end
    trait :illness do
      name { 'ILLNESS' }
    end
  end
end
