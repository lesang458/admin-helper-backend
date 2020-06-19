class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :birthdate, :join_date, :status, :phone_number
end
