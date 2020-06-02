FactoryBot.define do
  factory :employee do
    first_name { 'Tran' }
    last_name { 'Quang Huy' }
    birthday { '1999-10-30' }
    joined_company_date { '1999-01-01' }
    status { 'ACTIVE' }
    phone_number { '0123456789' }
    user
  end
end
