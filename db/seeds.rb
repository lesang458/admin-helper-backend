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

day_off_category_vacation = DayOffCategory.create! name: 'VACATION'
day_off_category_illness = DayOffCategory.create! name: 'ILLNESS'

admin.day_off_infos.create! day_off_category_id: day_off_category_vacation.id, hours: 160
admin.day_off_infos.create! day_off_category_id: day_off_category_illness.id, hours: 160

laptop = DeviceCategory.create! name: 'Laptop'
phone = DeviceCategory.create! name: 'Phone'
tablet = DeviceCategory.create! name: 'Tablet' 
monitor = DeviceCategory.create! name: 'Monitor'

mac_book = Device.create! name: 'MacBook Pro', price: 30_000_000, device_category_id: laptop.id
iphone = Device.create! name: 'Iphone 12 Pro Max', price: 39_990_000, device_category_id: phone.id
ipad = Device.create! name: 'IPad Pro 12.9 inch', price: 27_490_000, device_category_id: tablet.id
dell_monitor = Device.create! name: 'DELL E2020H', price: 2_290_000, device_category_id: monitor.id
macbook = Device.create! name: 'MacBook Pro', price: 30_000_000, device_category_id: laptop.id, user_id: employee.id

Device.create! name: 'DELL E2020H', price: 2_290_000, device_category_id: monitor.id

DeviceHistory.create! from_date: '2020-08-06', status: 'ASSIGNED', user_id: employee.id, device_id: macbook.id
DeviceHistory.create! from_date: '2020-08-06', status: 'DISCARDED', device_id: iphone.id
DeviceHistory.create! from_date: '2020-08-06', status: 'IN_INVENTORY', device_id: ipad.id

20.times do |i|
  DeviceHistory.create! from_date: Time.now, to_date: Time.now + 1.month, status: 'IN_INVENTORY', device_id: macbook.id
end

DeviceHistory.create! from_date: Time.now, to_date: Time.now + 1.month, status: 'ASSIGNED', device_id: iphone.id, user_id: 102
DeviceHistory.create! from_date: Time.now, to_date: Time.now + 1.month, status: 'DISCARDED', device_id: ipad.id

DeviceHistory.create! from_date: Time.now, status: 'ASSIGNED', device_id: mac_book.id
DeviceHistory.create! from_date: Time.now, status: 'ASSIGNED', device_id: dell_monitor.id

