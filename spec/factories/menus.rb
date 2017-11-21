FactoryGirl.define do
  factory :menu do
    association :user, factory: :user
    title { 'first menu' }
  end
end
