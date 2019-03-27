FactoryBot.define do
  factory :contact_center do
    sequence(:name) { |n| "center#{n}" }
  end
end