100.times do |i|
  user = User.create!(
    email: FFaker::Internet.email,
    encrypted_password: "12345678"
  )
  user.create_employee(
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name,
    birthday: FFaker::IdentificationESCO.expedition_date,
    joined_company_date: FFaker::IdentificationESCO.expedition_date,
    status: "ACTIVE"
  )
end
