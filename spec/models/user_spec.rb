require 'rails_helper'

describe User, :type => :model do
  describe 'relationships' do
    it { should have_one(:home_folder) }
  end

  describe 'whenever a user signs up' do
    let(:user) { create :user }

    it 'should have a home folder' do
      expect(user.home_folder).to be_present
      expect(user.home_folder.name).to eq('home')
    end
  end
end
