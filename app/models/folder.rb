class Folder
  include Mongoid::Document

  belongs_to :user
  belongs_to :folder
  has_many :folders

  field :name, type: String
end
