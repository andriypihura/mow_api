FactoryGirl.define do
  factory :like do
    association :user, factory: :user
    association :recipe, factory: :recipe
    value { true }
  end
end
