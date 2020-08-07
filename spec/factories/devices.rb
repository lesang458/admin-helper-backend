FactoryBot.define do
  factory :device do
    trait :iphone do
      name { 'Iphone 12 Pro Max' }
      price { 39_990_000 }
    end
    device_category

    trait :ipad do
      name { 'IPad Pro 12.9 inch' }
      price { 27_490_000 }
      device_category_id { tablet.id }
    end

    trait :mac_book do
      name { 'MacBook Pro' }
      price { 30_000_000 }
      device_category_id { laptop.id }
    end
  end
end
