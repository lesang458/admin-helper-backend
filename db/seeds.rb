100.times do |i|
  user = User.create email:"huytran.301099+#{i+1}@gmail.com", encrypted_password:"12345678"
  user.create_employee(first_name: "tran", last_name: "huy#{i+1}", birthday: "2020-06-25", joined_company_date: "2020-07-25", status: "ACTIVE")
end
