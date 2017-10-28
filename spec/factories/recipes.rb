FactoryGirl.define do
  factory :recipe do
    association :user, factory: :user
    title { Faker::Lorem.word }
  end
end
