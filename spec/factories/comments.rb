FactoryGirl.define do
  factory :comment do
    association :recipe, factory: :recipe
    association :user, factory: :user
    message { 'test message' }
  end
end
