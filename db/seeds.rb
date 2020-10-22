day_off_category_vacation = DayOffCategory.find_or_create_by name: 'VACATION', total_hours_default: 120, status: 'ACTIVE'
day_off_category_illness = DayOffCategory.find_or_create_by name: 'ILLNESS', total_hours_default: 16, status: 'INACTIVE'
day_off_category_maternity = DayOffCategory.find_or_create_by name: 'MATERNITY', total_hours_default: 160, status: 'ACTIVE'

employee = User.create_with(
  email: "employee@gmail.com",
  password: "123456",
  first_name: "employee",
  last_name: "user",
  birthdate: "2000-02-02",
  join_date: "2019-02-02",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE]
).find_or_create_by(email: 'employee@gmail.com')
info_vacation =  employee.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
employee.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default

admin = User.create_with(
  email: "admin@gmail.com",
  password: "123456",
  first_name: "admin",
  last_name: "user",
  birthdate: "2000-02-02",
  join_date: "2019-02-02",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN]
).find_or_create_by(email: 'admin@gmail.com')
admin.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
info_illness = admin.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default

super_admin = User.create_with(
  email: "super_admin@gmail.com",
  password: "123456",
  first_name: "super_admin",
  last_name: "user",
  birthdate: "2000-02-02",
  join_date: "2019-02-02",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN SUPER_ADMIN]
).find_or_create_by(email: 'super_admin@gmail.com')
super_admin.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
super_admin.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default

hanh = User.create_with(
  email: "hanhle@novahub.vn",
  password: "123456",
  first_name: "dang",
  last_name: "hanh",
  birthdate: "1999-02-02",
  join_date: "2019-11-25",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN SUPER_ADMIN]
).find_or_create_by(email: 'hanhle@novahub.vn')
hanh.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
hanh.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default

huy = User.create_with(
  email: "huytran@novahub.vn",
  password: "123456",
  first_name: "huy",
  last_name: "tran",
  birthdate: "1999-01-01",
  join_date: "2019-11-25",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN SUPER_ADMIN]
).find_or_create_by(email: 'huytran@novahub.vn')
huy.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
huy.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default

aulu = User.create_with(
  email: "aulu@novahub.vn",
  password: "123456",
  first_name: "Lu Tuyet",
  last_name: "Au",
  birthdate: "1999-01-01",
  join_date: "2019-11-25",
  status: "ACTIVE",
  phone_number: "0935270046",
  roles: %w[EMPLOYEE ADMIN SUPER_ADMIN]
).find_or_create_by(email: 'aulu@novahub.vn')
aulu.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
aulu.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default

100.times do |i|
  user = User.create_with(
    email: "user_#{i}@gmail.com",
    password: "123456",
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name,
    birthdate: "2000-02-02",
    join_date: "2019-02-02",
    status: "ACTIVE",
    phone_number: "0123456789",
    roles: %w[EMPLOYEE]
  ).find_or_create_by(email: "user_#{i}@gmail.com")
  user.day_off_infos.find_or_create_by day_off_category_id: day_off_category_vacation.id, hours: day_off_category_vacation.total_hours_default
  user.day_off_infos.find_or_create_by day_off_category_id: day_off_category_illness.id, hours: day_off_category_illness.total_hours_default
end

laptop = DeviceCategory.find_or_create_by name: 'Laptop'
phone = DeviceCategory.find_or_create_by name: 'Phone'
tablet = DeviceCategory.find_or_create_by name: 'Tablet' 
monitor = DeviceCategory.find_or_create_by name: 'Monitor'

mac_book = Device.create_with(
  name: "Mac Book Pro",
  price: 30_000_000,
  device_category_id: laptop.id,
  user_id: nil
).find_or_create_by(name: 'Mac Book Pro')
mac_book_history = mac_book.device_histories.create_with(
  from_date: '2019-02-02',
  to_date: nil,
  status: 'IN_INVENTORY',
  device_id: mac_book.id,
).find_or_create_by(from_date: '2019-02-02', status: 'IN_INVENTORY', device_id: mac_book.id)

iphone = Device.create_with(
  name: "Iphone 12 Pro Max",
  price: 39_990_000,
  device_category_id: phone.id,
  user_id: nil
).find_or_create_by(name: 'Iphone 12 Pro Max')
iphone_history = iphone.device_histories.create_with(
  from_date: '2019-02-02',
  to_date: nil,
  status: 'ASSIGNED',
  device_id: mac_book.id,
).find_or_create_by(from_date: '2019-02-02', status: 'ASSIGNED', device_id: iphone.id)

ipad = Device.create_with(
  name: "IPad Pro 12.9 inch",
  price: 27_490_000,
  device_category_id: tablet.id,
  user_id: nil
).find_or_create_by(name: 'IPad Pro 12.9 inch')
ipad_history = ipad.device_histories.create_with(
  from_date: '2019-02-02',
  to_date: nil,
  status: 'IN_INVENTORY',
  device_id: ipad.id,
).find_or_create_by(from_date: '2019-02-02', status: 'ASSIGNED', device_id: ipad.id)

dell_monitor = Device.create_with(
  name: "DELL E2019H",
  price: 2_290_000,
  device_category_id: monitor.id,
  user_id: nil
).find_or_create_by(name: 'DELL E2019H')
dell_monitor_history = dell_monitor.device_histories.create_with(
  from_date: '2019-02-02',
  to_date: nil,
  status: 'IN_INVENTORY',
  device_id: ipad.id,
).find_or_create_by(from_date: '2019-02-02', status: 'IN_INVENTORY', device_id: dell_monitor.id)

DeviceHistory.create_with(
  from_date: '2019-08-08',
  to_date: nil,
  status: 'ASSIGNED',
  device_id: mac_book.id,
  user_id: employee.id
).find_or_create_by(from_date: '2019-08-08', status: 'ASSIGNED', device_id: mac_book.id)
mac_book_history.update!(to_date: '2019-08-08')
mac_book.update!(user_id: employee.id)

DeviceHistory.create_with(
  from_date: '2019-09-06',
  status: 'IN_INVENTORY',
  device_id: iphone.id
).find_or_create_by(from_date: '2019-09-06', status: 'IN_INVENTORY', device_id: iphone.id)
iphone_history.update!(to_date: '2019-09-06')
iphone.update!(user_id: nil)

DeviceHistory.create_with(
  from_date: '2019-09-09',
  to_date: nil,
  status: 'DISCARDED',
  device_id: ipad.id
).find_or_create_by(from_date: '2019-09-09', status: 'DISCARDED', device_id: ipad.id)
ipad_history.update!(to_date: '2019-09-09')
ipad.update!(user_id: nil)

DeviceHistory.create_with(
  from_date: '2019-08-08',
  to_date: nil,
  status: 'ASSIGNED',
  device_id: dell_monitor.id,
  user_id: employee.id
).find_or_create_by(from_date: '2019-08-08', status: 'ASSIGNED', device_id: dell_monitor.id)
dell_monitor_history.update!(to_date: '2019-08-08')
dell_monitor.update!(user_id: employee.id)

employee.day_off_requests.create_with(
  from_date: '2020-02-02',
  to_date: '2020-02-10',
  hours_per_day: 4,
  notes: 'travel with family',
  day_off_info_id: info_vacation.id
).find_or_create_by(day_off_info_id: info_vacation.id, notes: 'travel with family')

admin.day_off_requests.create_with(
  from_date: '2020-02-02',
  to_date: '2020-02-04',
  hours_per_day: 4,
  notes: 'go to hospital',
  day_off_info_id: info_illness.id
).find_or_create_by(day_off_info_id: info_illness.id, notes: 'go to hospital')