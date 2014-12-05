require 'rails_helper'

describe User, :type => :model do
  describe 'relationships' do
    it { should have_many(:folders) }
  end
end
