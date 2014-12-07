FactoryGirl.define do
  factory :gridfs_file do
    name { Faker::Lorem.word }
    folder { create :folder }
    file_id {
      sentences = Random.rand(37)
      stream = StringIO.new(Faker::Lorem.paragraph(sentences))
      Mongoid::GridFs.put(stream).id
    }
  end
end
