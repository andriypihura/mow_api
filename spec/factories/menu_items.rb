FactoryGirl.define do
  factory :menu_item do
    association :menu, factory: :menu
    association :recipe, factory: :recipe
    primary_label { Date::DAYNAMES[rand(7)] }
  end
end
