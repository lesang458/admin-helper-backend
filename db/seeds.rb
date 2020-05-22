100.times do |i|
  user = User.create!(
    email: FFaker::Internet.email,
    encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a"
  )
  user.create_employee(
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name,
    birthday: FFaker::IdentificationESCO.expedition_date,
    joined_company_date: FFaker::IdentificationESCO.expedition_date,
    status: "ACTIVE",
    phone_number: "0123456789"
  )
end
