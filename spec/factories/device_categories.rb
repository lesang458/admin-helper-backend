FactoryBot.define do
  factory :device_category do
    trait :phone do
      name { 'Iphone' }
    end
    trait :laptop do
      name { 'Laptop' }
    end
    trait :tablet do
      name { 'Tablet' }
    end
    trait :monitor do
      name { 'Monitor' }
    end
  end
end
