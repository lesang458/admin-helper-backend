day_off_category_vacation = DayOffCategory.find_or_create_by name: 'VACATION', total_hours_default: 120
day_off_category_illness = DayOffCategory.find_or_create_by name: 'ILLNESS', total_hours_default: 16

employee = User.find_or_create_by(
  email: "employee@gmail.com",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: "employee",
  last_name: "user",
  birthdate: "2000-02-02",
  join_date: "2019-02-02",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE]
)
employee.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
employee.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default

admin = User.find_or_create_by(
  email: "admin@gmail.com",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: "admin",
  last_name: "user",
  birthdate: "2000-02-02",
  join_date: "2019-02-02",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN]
)
admin.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
admin.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default

super_admin = User.find_or_create_by(
  email: "super_admin@gmail.com",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: "super_admin",
  last_name: "user",
  birthdate: "2000-02-02",
  join_date: "2019-02-02",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN SUPER_ADMIN]
)
super_admin.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
super_admin.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default

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
hanh.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
hanh.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default

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
huy.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
huy.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default

aulu = User.find_or_create_by(
  email: "aulu@novahub.vn",
  encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
  first_name: "Lu Tuyet",
  last_name: "Au",
  birthdate: "1999-01-01",
  join_date: "2019-11-25",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN SUPER_ADMIN]
)
aulu.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
aulu.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default

100.times do |i|
  user = User.find_or_create_by(
    email: "user_#{i}@gmail.com",
    encrypted_password: "$2a$12$SOZBwu5y98li6GOqTOlKn.Twxft0wCwgwNQuzeFe62rYJcfQTsM8a",
    first_name: "fake",
    last_name: "user",
    birthdate: "2000-02-02",
    join_date: "2019-02-02",
    status: "ACTIVE",
    phone_number: "0123456789",
    roles: %w[EMPLOYEE]
  )
  user.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
  user.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default
end

laptop = DeviceCategory.find_or_create_by name: 'Laptop'
phone = DeviceCategory.find_or_create_by name: 'Phone'
tablet = DeviceCategory.find_or_create_by name: 'Tablet' 
monitor = DeviceCategory.find_or_create_by name: 'Monitor'

mac_book = Device.find_or_create_by name: 'Mac Book Pro', price: 30_000_000, device_category_id: laptop.id, user_id: nil
mac_book_history = mac_book.device_histories.find_or_create_by from_date: '2019-02-02', status: 'IN_INVENTORY', device_id: mac_book.id

iphone = Device.find_or_create_by name: 'Iphone 12 Pro Max', price: 39_990_000, device_category_id: phone.id, user_id: nil
iphone_history = iphone.device_histories.find_or_create_by from_date: '2019-02-02', status: 'IN_INVENTORY', device_id: iphone.id

ipad = Device.find_or_create_by name: 'IPad Pro 12.9 inch', price: 27_490_000, device_category_id: tablet.id, user_id: nil
ipad_history = ipad.device_histories.find_or_create_by from_date: '2019-02-02', status: 'IN_INVENTORY', device_id: ipad.id

dell_monitor = Device.find_or_create_by name: 'DELL E2019H', price: 2_290_000, device_category_id: monitor.id, user_id: nil
dell_monitor_history = dell_monitor.device_histories.find_or_create_by from_date: '2019-02-02', status: 'IN_INVENTORY', device_id: dell_monitor.id

mac_book_history.update!(to_date: '2019-08-08')
DeviceHistory.find_or_create_by from_date: '2019-08-08', to_date: '2019-09-09', status: 'ASSIGNED', device_id: mac_book.id, user_id: employee.id
mac_book.update!(user_id: employee.id)
DeviceHistory.find_or_create_by from_date: '2019-09-09', to_date: '2019-10-10', status: 'ASSIGNED', device_id: mac_book.id, user_id: admin.id
mac_book.update!(user_id: admin.id)
DeviceHistory.find_or_create_by from_date: '2019-10-10', to_date: '2019-10-10', status: 'IN_INVENTORY', device_id: mac_book.id
mac_book.update!(user_id: nil)

iphone_history.update!(to_date: '2019-08-08')
DeviceHistory.find_or_create_by from_date: '2019-08-08', to_date: '2019-09-09', status: 'ASSIGNED', device_id: iphone.id, user_id: admin.id
iphone.update!(user_id: admin.id)
DeviceHistory.find_or_create_by from_date: '2019-09-06', status: 'DISCARDED', device_id: iphone.id
iphone.update!(user_id: nil)

ipad_history.update!(to_date: '2019-09-09')
DeviceHistory.find_or_create_by from_date: '2019-09-09', to_date: '2019-09-09', status: 'DISCARDED', device_id: ipad.id
ipad.update!(user_id: nil)

dell_monitor_history.update!(to_date: '2019-08-08')
DeviceHistory.find_or_create_by from_date: '2019-08-08', status: 'ASSIGNED', device_id: dell_monitor.id, user_id: employee.id
dell_monitor.update!(user_id: employee.id)
