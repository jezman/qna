FactoryBot.define do
  sequence :title do |n|
    "Title #{n}"
  end

  sequence :body do |n|
    "Body #{n}"
  end

  factory :question do
    title
    body
  end

  trait :invalid_email do
    title { nil }
  end
end
