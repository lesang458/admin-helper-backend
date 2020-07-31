FactoryBot.define do
  factory :device do
    trait :iphone do
      name { 'Iphone 12 Pro Max' }
      price { 39_990_000 }
    end
    device_category_id { DeviceCategory.first.id }
  end
end
