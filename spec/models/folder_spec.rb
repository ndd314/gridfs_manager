require 'rails_helper'

RSpec.describe Folder, :type => :model do
  describe 'relationships' do
    it { should have_many(:folders) }
    it { should belong_to(:folder) }
    it { should belong_to(:user) }
  end
end
