require 'rails_helper'

describe User, :type => :model do
  describe 'relationships' do
    it { should have_many(:folders) }
  end

  describe 'whenever a user signs up' do
    let!(:user) { create :user }

    it 'should have a root folder created' do
      user.folders.count.should == 1
    end
  end
end
