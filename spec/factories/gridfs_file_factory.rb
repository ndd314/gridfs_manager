FactoryGirl.define do
  factory :gridfs_file do
    name { Faker::Lorem.word }
    folder { create :folder }
    file_id {
      stream = StringIO.new(Faker::Lorem.paragraph(37))
      Mongoid::GridFs.put(stream).id
    }
  end
end
