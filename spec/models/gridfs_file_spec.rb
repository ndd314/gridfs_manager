require 'rails_helper'

describe GridfsFile, :type => :model do
  describe 'relationships for a file' do
    it { should belong_to(:folder) }
    it { should validate_presence_of :folder }
    it { should validate_presence_of :name }
  end

  describe '#owner' do
    subject { create :gridfs_file }
    it 'returns the user who is the owner of the file' do
      expect(subject.folder).to be_present
      expect(subject.owner).to eq(subject.folder.owner)
    end
  end

  describe 'validation for actual file storage' do
    let!(:folder) { create :folder }
    subject { GridfsFile.new name: 'a_new_file', folder: folder }

    context 'when a file is uploaded to grid_fs' do
      let(:file) { StringIO.new('file contents') }
      before { subject.upload!(file) }
      its(:valid?) { should be_truthy }
    end

    context 'when a file has not been uploaded to grid_fs' do
      its(:valid?) { should be_falsey }
    end
  end

  describe 'filename validations' do
    describe 'filename uniqueness' do
      let(:folder) { create :folder }
      let(:gridfs_file) { create :gridfs_file, folder: folder }

      let(:folder_new) { create :folder }
      let(:dup_gridfs_file_diff_folder) { create :gridfs_file, folder: folder_new, name: gridfs_file.name }

      it 'does not allow duplicate filenames for the same folder' do
        new_gridfs_file = GridfsFile.new(name: gridfs_file.name, folder: folder)
        new_gridfs_file.valid?
        expect(new_gridfs_file.errors.messages[:name]).to be_present
      end

      it 'does allow duplicate filenames for the different folder' do
        dup_gridfs_file_diff_folder.valid?
        expect(dup_gridfs_file_diff_folder.errors.messages[:name]).to_not be_present
      end
    end

    describe 'filename legal characters' do
      subject { GridfsFile.new(name: file_name) }

      before { subject.valid? }

      context 'when name is empty' do
        let(:file_name) { '' }
        it { expect(subject.errors.messages[:name]).to be_present }
      end

      context 'when name contains the path separator' do
        let (:file_name) { 'abc/abc.txt' }
        it { expect(subject.errors.messages[:name]).to be_present }
      end

      context 'when name contains none alpha-numberic' do
        let (:file_name) { 'abc$abc' }
        it { expect(subject.errors.messages[:name]).to be_present }
      end

      context 'when name contains a period' do
        let (:file_name) { 'abc.abc' }
        it { expect(subject.errors.messages[:name]).to_not be_present }
      end
    end
  end

  describe 'when destroying gridfs_file' do
    let(:gridfs_file) { create :gridfs_file }

    before { gridfs_file.destroy }

    it 'should also delete the actual gridfs object' do
      expect { Mongoid::GridFs.get(gridfs_file.file_id) }.to raise_exception
    end
  end

  describe 'delegation to grid_fs_file' do
    let(:gridfs_file) { create :gridfs_file }
    let(:actual_gridfs_file) { Mongoid::GridFs.get(gridfs_file.file_id) }

    it 'should returns :length, :chunkSize, :uploadDate, :md5, :contentType, :metadata, :data, :data_uri' do
      expect(gridfs_file.length).to eq(actual_gridfs_file.length)
      expect(gridfs_file.chunkSize).to eq(actual_gridfs_file.chunkSize)
      expect(gridfs_file.uploadDate).to eq(actual_gridfs_file.uploadDate)
      expect(gridfs_file.md5).to eq(actual_gridfs_file.md5)
      expect(gridfs_file.contentType).to eq(actual_gridfs_file.contentType)
      expect(gridfs_file.metadata).to eq(actual_gridfs_file.metadata)
      expect(gridfs_file.data).to eq(actual_gridfs_file.data)
      expect(gridfs_file.data_uri.size).to eq(actual_gridfs_file.data_uri.size)
    end
  end
end
