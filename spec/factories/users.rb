FactoryBot.define do
  sequence :email do |n|
    "test#{n}@domain.com"
  end

  factory :user do
    email
    password { '12344556' }
    confirmed_at Time.current.to_s
  end
end
