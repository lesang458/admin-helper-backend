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

employee = User.create!(
  email: "employee@gmail.com",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: FFaker::Name.first_name,
  last_name: FFaker::Name.last_name,
  birthdate: FFaker::IdentificationESCO.expedition_date,
  join_date: FFaker::IdentificationESCO.expedition_date,
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE]
)

admin = User.create!(
  email: "admin@gmail.com",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: FFaker::Name.first_name,
  last_name: FFaker::Name.last_name,
  birthdate: FFaker::IdentificationESCO.expedition_date,
  join_date: FFaker::IdentificationESCO.expedition_date,
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN]
)

super_admin = User.create!(
  email: "super_admin@gmail.com",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: FFaker::Name.first_name,
  last_name: FFaker::Name.last_name,
  birthdate: FFaker::IdentificationESCO.expedition_date,
  join_date: FFaker::IdentificationESCO.expedition_date,
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN SUPER_ADMIN]
)

User.create!(
  email: "hanhle@novahub.vn",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: "dang",
  last_name: "hanh",
  birthdate: "1999-02-02",
  join_date: "2019-11-25",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN SUPER_ADMIN]
)

User.create!(
  email: "huytran@novahub.vn",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: "huy",
  last_name: "tran",
  birthdate: "1999-01-01",
  join_date: "2019-11-25",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN SUPER_ADMIN]
)

day_off_category_vacation = DayOffCategory.create! name: 'VACATION'
day_off_category_illness = DayOffCategory.create! name: 'ILLNESS'

admin.day_off_infos.create! day_off_category_id: day_off_category_vacation.id, hours: 160
admin.day_off_infos.create! day_off_category_id: day_off_category_illness.id, hours: 160

laptop = DeviceCategory.create! name: 'Laptop'
phone = DeviceCategory.create! name: 'Phone'
tablet = DeviceCategory.create! name: 'Tablet' 
monitor = DeviceCategory.create! name: 'Monitor'

Device.create! name: 'MacBook Pro', price: 30_000_000, device_category_id: laptop.id
Device.create! name: 'Iphone 12 Pro Max', price: 39_990_000, device_category_id: phone.id
Device.create! name: 'IPad Pro 12.9 inch', price: 27_490_000, device_category_id: tablet.id
Device.create! name: 'DELL E2020H', price: 2_290_000, device_category_id: monitor.id