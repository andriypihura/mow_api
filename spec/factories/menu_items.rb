FactoryGirl.define do
  factory :menu_item do
    association :menu, factory: :menu
    association :recipe, factory: :recipe
    primary_label { 'monday' }
  end
end
