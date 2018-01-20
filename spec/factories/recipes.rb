FactoryGirl.define do
  factory :recipe do
    association :user, factory: :user
    title { Faker::Lorem.word }
    text { Faker::Lorem.paragraph(3) }
    ingredients { Faker::Lorem.words(4).join(',') }

    trait :public do
      visibility { 'public' }
    end
  end
end
