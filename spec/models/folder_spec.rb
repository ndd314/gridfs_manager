require 'rails_helper'

describe Folder, :type => :model do
  describe 'relationships' do
    it { should have_many(:sub_folders) }
    it { should belong_to(:parent_folder) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }

    context 'when name is empty' do
      it 'should not be valid' do
        my_folder = Folder.new(name: '')
        expect(my_folder.valid?).to be_falsey
      end
    end

    context 'when validate folder names' do
      let!(:home_folder) { create :folder, name: 'home' }
      let!(:child_folder) { create :folder, name: 'child', parent_folder: home_folder }

      context 'when folders belonging to the same parent folder' do
        it 'folder names must be unique' do
          dup_folder = Folder.create(name: 'child', parent_folder: home_folder)
          expect(dup_folder.valid?).to be_falsey
        end
      end

      context 'when folders belonging to the same parent folder' do
        it 'folder names must be unique' do
          diff_parent_folder = Folder.create(name: 'child')
          expect(diff_parent_folder.valid?).to be_truthy
        end
      end

      context 'when parent folders are nil - these are home folders' do
        it 'allows duplicated names' do
          another_home = Folder.create(name: 'home')
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
    let(:child_folder) { create :folder, name: 'abc', parent_folder: home_folder }

    it 'returns the full path to the folder' do
      expect(home_folder.full_path).to eq("/home")
      expect(child_folder.full_path).to eq("/home/abc")
    end
  end
end
