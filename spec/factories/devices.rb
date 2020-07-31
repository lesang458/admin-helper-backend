FactoryBot.define do
  factory :device do
    name { 'first device' }
    price { 1000 }
    description { 'description' }
    user
  end
end
