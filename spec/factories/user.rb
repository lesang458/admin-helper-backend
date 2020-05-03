FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    encrypted_password { '$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a' } #123456
  end
end
