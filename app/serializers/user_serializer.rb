class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :birthday, :joined_company_date, :status, :phone_number
end
