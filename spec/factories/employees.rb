FactoryBot.define do
  factory :employee do
    first_name { "MyString" }
    last_name { "MyString" }
    birthday { "2020-04-25" }
    joined_company_date { "2020-04-25" }
    status { "ACTIVE" }
    user
  end
end
