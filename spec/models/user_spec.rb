require 'rails_helper'

describe User, :type => :model do
  subject { create(:user) }

  describe 'relationships' do
    it { should have_one(:home_folder) }
  end

  describe 'whenever a user signs up' do
    it 'should have a home folder' do
      expect(subject.home_folder).to be_present
      expect(subject.home_folder.name).to eq('home')
      expect(subject.home_folder.home_folder?).to be_truthy
    end
  end

  describe '#delete' do
    it 'does not allow direct db delete' do
      expect { subject.delete }.to raise_exception
    end
  end

  describe '#destroy' do
    it 'also destroy the home folder' do
      subject.destroy
      expect(subject).to be_frozen
      expect(subject.home_folder).to be_frozen
    end
  end
end
