FactoryGirl.define do
  factory :comment do
    association :user, factory: :user
    association :recipe, factory: :recipe
    message { 'test message' }
  end
end
