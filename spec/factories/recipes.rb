FactoryGirl.define do
  factory :recipe do
    association :user, factory: :user
    title { Faker::Lorem.word }

    trait :public do
      visibility { 'public' }
    end
  end
end
