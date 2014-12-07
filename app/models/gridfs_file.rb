class GridfsFile
  # class GridFsFileException < StandardError; end

  include Mongoid::Document

  belongs_to :folder

  validates_presence_of :folder, :name
  validates_format_of :name, with: /\A[a-z0-9 \-_]*\Z/i
  validates_uniqueness_of :name, scope: :folder
  validates_presence_of :file_id, message: 'File has not been uploaded'
  validate :file_exists_on_gridfs

  delegate :owner, to: :folder
  delegate :length, :chunkSize, :uploadDate, :md5, :contentType, :metadata, to: :grid_fs_file

  after_destroy :delete_grid_fs_file

  field :name, type: String
  field :file_id, type: String

  def upload!(stream)
    @grid_fs_file = grid_fs.put(stream)
    self.file_id = grid_fs_file.id
  end

  # def download
  #   raise GridFsFileException.new('Download is not possible') if file_id.nil?
  #   grid_fs.get(file_id)
  # end

  private

  def delete_grid_fs_file
    grid_fs.delete(file_id)
  end

  def file_exists_on_gridfs
    grid_fs_file rescue errors.add(:base, 'File does not exist in GridFS')
  end

  def grid_fs_file
    @grid_fs_file ||= grid_fs.get(file_id)
  end

  def grid_fs
    @grid_fs ||= Mongoid::GridFs
  end
end
