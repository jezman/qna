FactoryBot.define do
  factory :badge do
    title { 'Badge' }
    image { Rails.root.join('app/assets/images/badges/default.png').to_s }
  end
end
