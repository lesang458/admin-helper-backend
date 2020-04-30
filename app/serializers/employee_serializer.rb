class EmployeeSerializer < ActiveModel::Serializer
  attributes :user_email, :first_name, :last_name, :birthday, :joined_company_date, :status
end
