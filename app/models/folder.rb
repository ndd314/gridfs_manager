class Folder
  class FolderException < StandardError; end
  include Mongoid::Document

  PATH_SEPARATOR = '/'

  belongs_to :owner, class_name: 'User'
  belongs_to :parent_folder, class_name: 'Folder'
  has_many :sub_folders, class_name: 'Folder', dependent: :destroy
  has_many :files, class_name: 'GridfsFile', dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :parent_folder, unless: :home_folder?
  validates_format_of :name, with: /\A[a-z0-9 \-_\.]*\Z/i
  validates_presence_of :owner
  validate :same_owner_as_parent

  after_initialize :copy_owner_from_parent_folder

  field :name, type: String

  def full_path
    return parent_folder.full_path + PATH_SEPARATOR + name if parent_folder
    PATH_SEPARATOR + name
  end

  def home_folder?
    parent_folder.nil?
  end

  def contents_empty?
    sub_folders.empty? && files.empty?
  end

  def destroy(recursive: nil)
    if contents_empty? || recursive
      super
    else
      raise FolderException.new('Folder is not empty')
    end
  end

  def folders_from_home
    return parent_folder.folders_from_home << self if parent_folder
    [self]
  end

  private

  def copy_owner_from_parent_folder
    self.owner ||= parent_folder.owner if parent_folder
  end

  def same_owner_as_parent
    return unless parent_folder && owner
    errors[:owner] << 'Folder must have the same owner as its parent' if parent_folder.owner.id != owner.id
  end

  def delete(options={})
    super
  end
end
