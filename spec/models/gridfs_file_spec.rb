require 'rails_helper'

describe GridfsFile, :type => :model do
  describe 'relationships' do
    it { should belong_to(:folder) }
  end
end
