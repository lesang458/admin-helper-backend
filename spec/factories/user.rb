FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    # 123456
    encrypted_password { '$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a' }
  end
end
