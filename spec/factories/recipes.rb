FactoryGirl.define do
  factory :recipe do
    association :user, factory: :user
    title { Faker::Lorem.words(rand(1..4)).join(' ') }
    text { Faker::Lorem.paragraph(rand(8..12)) }
    ingredients { Faker::Lorem.words(rand(5..10)).join(',') }
    calories { rand(30..1200) }
    complexity { %w[hard easy normal].sample }
    time_consuming { rand(10..300) }

    trait :public do
      visibility { 'public' }
    end
  end
end
