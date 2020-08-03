FactoryBot.define do
  factory :device_history do
    from_date { '2020-07-31 09:46:06' }
    to_date { '2020-07-31 09:46:06' }
    trait :DISCARDED do
      status { 'DISCARDED' }
    end
    trait :ASSIGNED do
      status { 'ASSIGNED' }
    end
    trait :INVENTORY do
      status { 'INVENTORY' }
    end
    user
    device
  end
end
