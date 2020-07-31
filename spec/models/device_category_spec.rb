require 'rails_helper'

RSpec.describe DeviceCategory, type: :model do
  describe 'name of device caategory' do
    it { should respond_to(:name) }
    it { should allow_value('laptop').for(:name) }
    it { should validate_presence_of(:name) }
    it { should_not allow_value(' ').for(:name) }
  end

  describe 'description' do
    it { should respond_to(:description) }
    it { should allow_value(' ').for(:description) }
    it { should allow_value('description').for(:description) }
    it { should_not validate_presence_of(:description) }
  end
end
