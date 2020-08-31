day_off_category_vacation = DayOffCategory.find_or_create_by name: 'VACATION'
day_off_category_illness = DayOffCategory.find_or_create_by name: 'ILLNESS'

employee = User.find_or_create_by(
  email: "employee@gmail.com",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: "employee",
  last_name: "user",
  birthdate: "2000-02-02",
  join_date: "2020-02-02",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE]
)
employee.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: 160
employee.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: 160

admin = User.find_or_create_by(
  email: "admin@gmail.com",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: "admin",
  last_name: "user",
  birthdate: "2000-02-02",
  join_date: "2020-02-02",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN]
)

super_admin = User.find_or_create_by(
  email: "super_admin@gmail.com",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: "super_admin",
  last_name: "user",
  birthdate: "2000-02-02",
  join_date: "2020-02-02",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN SUPER_ADMIN]
)
super_admin.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: 160
super_admin.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: 160

hanh = User.find_or_create_by(
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
hanh.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: 160
hanh.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: 160

huy = User.find_or_create_by(
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
huy.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: 160
huy.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: 160

100.times do |i|
  user = User.find_or_create_by(
    email: "user_#{i}@gmail.com",
    encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
    first_name: "fake",
    last_name: "user",
    birthdate: "2000-02-02",
    join_date: "2020-02-02",
    status: "ACTIVE",
    phone_number: "0123456789",
    roles: %w[EMPLOYEE]
  )
  user.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: 160
  user.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: 160
end

admin.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: 160
admin.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: 160

laptop = DeviceCategory.find_or_create_by name: 'Laptop'
phone = DeviceCategory.find_or_create_by name: 'Phone'
tablet = DeviceCategory.find_or_create_by name: 'Tablet' 
monitor = DeviceCategory.find_or_create_by name: 'Monitor'

mac_book = Device.find_or_create_by name: 'MacBook Pro', price: 30_000_000, device_category_id: laptop.id
iphone = Device.find_or_create_by name: 'Iphone 12 Pro Max', price: 39_990_000, device_category_id: phone.id
ipad = Device.find_or_create_by name: 'IPad Pro 12.9 inch', price: 27_490_000, device_category_id: tablet.id
dell_monitor = Device.find_or_create_by name: 'DELL E2020H', price: 2_290_000, device_category_id: monitor.id
macbook = Device.find_or_create_by name: 'MacBook Pro', price: 30_000_000, device_category_id: laptop.id, user_id: employee.id

Device.find_or_create_by name: 'DELL E2020H', price: 2_290_000, device_category_id: monitor.id

DeviceHistory.find_or_create_by from_date: '2020-08-06', status: 'ASSIGNED', user_id: employee.id, device_id: macbook.id
DeviceHistory.find_or_create_by from_date: '2020-08-06', status: 'DISCARDED', device_id: iphone.id
DeviceHistory.find_or_create_by from_date: '2020-08-06', status: 'IN_INVENTORY', device_id: ipad.id

20.times do |i|
  DeviceHistory.find_or_create_by from_date: '2020-08-06', to_date: '2020-09-06', status: 'IN_INVENTORY', device_id: macbook.id
end

DeviceHistory.find_or_create_by from_date: '2020-08-06', to_date: '2020-09-06', status: 'ASSIGNED', device_id: iphone.id, user_id: 102
DeviceHistory.find_or_create_by from_date: '2020-08-06', to_date: '2020-09-06', status: 'DISCARDED', device_id: ipad.id

DeviceHistory.find_or_create_by from_date: '2020-08-06', status: 'ASSIGNED', device_id: mac_book.id, user_id: employee.id
DeviceHistory.find_or_create_by from_date: '2020-08-06', status: 'ASSIGNED', device_id: dell_monitor.id, user_id: employee.id
