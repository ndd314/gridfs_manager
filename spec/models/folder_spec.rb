require 'rails_helper'

describe Folder, :type => :model do
  describe 'relationships' do
    it { should have_many(:sub_folders) }
    it { should have_many(:files) }
    it { should belong_to(:parent_folder) }
    it { should belong_to(:owner) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :owner }

    context 'when validating name format' do
      let(:current_user) { create :user }

      subject { Folder.new(name: folder_name, owner: current_user) }

      context 'when name is empty' do
        let(:folder_name) { '' }
        its(:valid?) { should be_falsey }
      end

      context 'when name contains the path separator' do
        let (:folder_name) { 'abc/abc' }
        its(:valid?) { should be_falsey }
      end

      context 'when name contains none alpha-numberic' do
        let (:folder_name) { 'abc$abc' }
        its(:valid?) { should be_falsey }
      end
    end

    context 'when validate folders uniqueness' do
      let!(:home_folder) { create :folder, name: 'home' }
      let!(:child_folder) { Folder.create name: 'child', parent_folder: home_folder }

      context 'when folders belonging to the same parent folder' do
        it 'folder names must be unique' do
          dup_folder = Folder.create(name: 'child', parent_folder: home_folder)
          expect(dup_folder.valid?).to be_falsey
        end
      end

      context 'when folders has different parent folder' do
        it 'folder names must be unique' do
          diff_parent_folder = create :folder, name: 'child'
          expect(diff_parent_folder.valid?).to be_truthy
        end
      end

      context 'when fodlers does not have parent' do
        it 'allows duplicated names' do
          another_home = create :folder, name: 'home'
          expect(another_home.valid?).to be_truthy
        end
      end
    end
  end

  describe '#home_folder?' do
    subject { Folder.create name: 'abc', parent_folder: parent_folder }

    context 'when a folder has no parent folder' do
      let(:parent_folder) { nil }
      its(:home_folder?) { should be_truthy }
    end

    context 'when a folder has a parent folder' do
      let(:parent_folder) { Folder.create name: 'parent' }
      its(:home_folder?) { should be_falsey }
    end
  end

  describe '#full_path' do
    let(:home_folder) { create :folder, name: 'home' }
    let(:child_folder) { Folder.create name: 'abc', parent_folder: home_folder }

    it 'returns the full path to the folder' do
      expect(home_folder.full_path).to eq("/home")
      expect(child_folder.full_path).to eq("/home/abc")
    end
  end

  describe '#contents_empty?' do
    subject { create(:folder) }

    context 'where folder does not contain sub-folders or files' do
      its(:contents_empty?) { should be_truthy }
    end

    context 'where folder contains sub-folders' do
      before { subject.sub_folders << create(:folder) }
      its(:contents_empty?) { should be_falsey }
    end

    context 'where folder contains files' do
      before { subject.files << create(:gridfs_file) }
      its(:contents_empty?) { should be_falsey }
    end
  end

  describe '#delete' do
    subject { create(:folder) }

    it 'does not allow direct db delete' do
      expect { subject.delete }.to raise_exception
    end
  end

  describe '#destroy' do
    subject { create(:folder) }

    context 'when folder is not empty' do
      let(:sub_folder) { create(:folder) }

      before { subject.sub_folders << sub_folder }

      context 'destroy without recursive' do
        it 'raises exception on destroy' do
          expect { subject.destroy }.to raise_exception
        end
      end

      context 'destroy with recursion' do
        it 'allows destroy with recursive' do
          expect { subject.destroy(recursive: true) }.to_not raise_exception
        end

        it 'destroy itself' do
          subject.destroy(recursive: true)
          expect(subject).to be_frozen
          expect { Folder.find(subject.id) }.to raise_error(Mongoid::Errors::DocumentNotFound)
        end

        it 'destroy sub_folders' do
          subject.destroy(recursive: true)
          expect { Folder.find(sub_folder.id) }.to raise_error(Mongoid::Errors::DocumentNotFound)
          expect(sub_folder).to be_frozen
        end

        it 'destroy its files' do
          gridfs_file = create(:gridfs_file)
          subject.files << gridfs_file

          subject.destroy(recursive: true)
          expect { GridfsFile.find(gridfs_file.id) }.to raise_error(Mongoid::Errors::DocumentNotFound)
          expect(gridfs_file).to be_frozen
        end
      end
    end
  end

  describe '#owner' do
    let(:owner) { create :user }
    let(:home_folder) { owner.home_folder }
    let(:folder1) { create :folder, parent_folder: home_folder, owner: owner }

    context 'for folder that is not a home folders' do
      it 'has the same owner has its parent folder' do
        expect(folder1.owner).to eq(home_folder.owner)
      end
    end

    context 'when creating a folder without an owner' do
      let(:parent_folder) { create :folder }
      let(:folder2) { Folder.create name: 'folder2', parent_folder: parent_folder }

      it 'has the same owner has its parent folder' do
        expect(folder2.owner).to eq(parent_folder.owner)
      end
    end

    context 'create folder with different owner than its parent' do
      let(:another_owner) { create :user }
      subject { create :folder, parent_folder: home_folder, owner: another_owner }

      it 'should raise an error' do
        expect {subject}.to raise_error
      end
    end
  end
end
