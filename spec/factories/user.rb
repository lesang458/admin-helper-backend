FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { '123456' }
    first_name { 'Admin' }
    last_name { 'Admin' }
    birthdate { '1990-01-01' }
    join_date { '1990-01-01' }
    status { 'ACTIVE' }
    phone_number { '0123456789' }
    trait :employee do
      roles { ['EMPLOYEE'] }
    end
    trait :admin do
      roles { %w[EMPLOYEE ADMIN] }
    end
    trait :super_admin do
      roles { %w[EMPLOYEE ADMIN SUPER_ADMIN] }
    end
  end
end
