FactoryBot.define do
  factory :link do
    name { "Thinknetica" }
    url { "http://thinknetica.com" }
  end

  trait :gist_link do
    name { "Gist" }
    url { "https://gist.github.com/jezman/a6c9a6c93f651b8b84ac6e08303e82ed" }
  end
end
