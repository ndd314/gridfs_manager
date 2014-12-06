class GridfsFile
  include Mongoid::Document

  belongs_to :folder

  field :name, type: String
end
