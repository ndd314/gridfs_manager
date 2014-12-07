FactoryGirl.define do
  factory :folder do
    owner { User.create }
    name { Faker::Lorem.word }
  end
end
