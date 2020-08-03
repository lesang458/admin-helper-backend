require 'rails_helper'

RSpec.describe DeviceHistory, type: :model do
  describe 'from date' do
    it { should respond_to(:from_date) }
    it { should validate_presence_of(:from_date) }
    it { should allow_value('2020-12-12').for(:from_date) }
    it { should_not allow_value('2020').for(:from_date) }
  end

  describe 'status' do
    it { should respond_to(:status) }
    it { should allow_value('DISCARDED').for(:status) }
    it { should allow_value('ASSIGNED').for(:status) }
    it { should allow_value('INVENTORY').for(:status) }
    it { should_not allow_value('').for(:status) }
  end

  describe DeviceHistory do
    it { should belong_to(:device) }
    it { should belong_to(:user) }
  end

  describe Device do
    it { should have_many(:device_histories) }
  end

  describe User do
    it { should have_many(:device_histories) }
  end
end
