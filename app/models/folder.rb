class Folder
  include Mongoid::Document
  field :name, type: String
  field :user_id, type Integer
end
