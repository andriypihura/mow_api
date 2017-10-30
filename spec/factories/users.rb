FactoryGirl.define do
  factory :user do
    name { Faker::Lorem.word }
  end
end
