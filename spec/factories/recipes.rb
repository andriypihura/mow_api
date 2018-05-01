FactoryGirl.define do
  factory :recipe do
    association :user, factory: :user
    title { Faker::Lorem.words(rand(1..4)).join(' ') }
    text { Faker::Lorem.paragraph(rand(8..12)) }
    ingredients { Faker::Lorem.words(rand(5..10)).join(',') }
    calories { rand(30..1200) }
    complexity { %w[hard easy normal].sample }
    time_consuming { rand(10..300) }
    image { ['http://res.cloudinary.com/darkee/image/upload/v1517575480/mmm_axrlzx.jpg',
             'http://res.cloudinary.com/darkee/image/upload/v1517575480/wreath_of3pnr.jpg',
             'http://res.cloudinary.com/darkee/image/upload/v1517575480/smth_strange_qu38c9.jpg',
             'http://res.cloudinary.com/darkee/image/upload/v1517575480/chicken_ltkejr.jpg',
             'http://res.cloudinary.com/darkee/image/upload/v1517574705/efoylvocrbda3c4gslf9.jpg',
             nil, nil, nil, nil, nil].sample }
    visibility { 'public' }

    trait :public do
      visibility { 'public' }
    end

    trait :with_image do

    end
  end
end
