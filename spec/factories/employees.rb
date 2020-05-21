FactoryBot.define do
  factory :employee do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    birthday { FFaker::IdentificationESCO.expedition_date }
    joined_company_date { FFaker::IdentificationESCO.expedition_date }
    status { 'ACTIVE' }
    phone_number { '0123456789' }
    user
  end
end
