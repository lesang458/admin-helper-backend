FactoryBot.define do
  factory :day_off_category do
    trait :vacation do
      name { 'VACATION' }
      total_hours_default { 120 }
    end
    trait :illness do
      name { 'ILLNESS' }
      total_hours_default { 16 }
    end
    trait :maternity do
      name { 'MATERNITY' }
      total_hours_default { 120 }
    end
  end
end
