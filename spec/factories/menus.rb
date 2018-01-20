FactoryGirl.define do
  factory :menu do
    association :user, factory: :user
    title { Faker::Lorem.word }
  end
end
