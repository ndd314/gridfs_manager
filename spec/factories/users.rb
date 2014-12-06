FactoryGirl.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password "Password123$"
    password_confirmation "Password123$"
  end
end
