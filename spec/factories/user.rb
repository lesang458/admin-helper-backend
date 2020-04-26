FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    encrypted_password { "12345678" }
  end
end
