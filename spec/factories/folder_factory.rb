FactoryGirl.define do
  factory :folder do
    name "MyString"

    user { User.create }
  end
end
