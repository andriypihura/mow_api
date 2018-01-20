FactoryGirl.define do
  factory :comment do
    association :recipe, factory: :recipe
    association :user, factory: :user
    message { Faker::Lorem.paragraph(1) }
  end
end
