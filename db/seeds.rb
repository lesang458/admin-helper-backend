100.times do |i|
  user = User.create!(
    email: FFaker::Internet.email,
    encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name,
    birthdate: FFaker::IdentificationESCO.expedition_date,
    join_date: FFaker::IdentificationESCO.expedition_date,
    status: "ACTIVE",
    phone_number: "0123456789",
    roles: %w[EMPLOYEE]
  )
end

former_user = User.create!(
  email: "admin@gmail.com",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: FFaker::Name.first_name,
  last_name: FFaker::Name.last_name,
  birthdate: FFaker::IdentificationESCO.expedition_date,
  join_date: FFaker::IdentificationESCO.expedition_date,
  status: "FORMER",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN]
)

DayOffCategory.create! name: 'VACATION'

DayOffCategory.create! name: 'ILLNESS'