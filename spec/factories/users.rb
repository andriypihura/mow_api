FactoryGirl.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { '12345678' }
    password_confirmation { '12345678' }
  end
end
