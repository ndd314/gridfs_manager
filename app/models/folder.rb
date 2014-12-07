class Folder
  include Mongoid::Document

  PATH_SEPARATOR = '/'

  belongs_to :user
  belongs_to :parent_folder, class_name: 'Folder'
  has_many :sub_folders, class_name: 'Folder'

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :parent_folder, unless: :home_folder?
  validates_format_of :name, with: /\A[a-z0-9 \-_]*\Z/i
  validates_presence_of :user

  field :name, type: String

  def full_path
    return parent_folder.full_path + PATH_SEPARATOR + name if parent_folder
    PATH_SEPARATOR + name
  end

  def home_folder?
    parent_folder.nil?
  end
end
