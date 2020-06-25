FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    # 123456
    encrypted_password { '$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a' }
    first_name { 'Admin' }
    last_name { 'Admin' }
    birthdate { '1990-01-01' }
    join_date { '1990-01-01' }
    status { 'ACTIVE' }
    phone_number { '0123456789' }
    roles { ['EMPLOYEE'] }
  end
end
