require 'rails_helper'

RSpec.describe DeviceCategory, type: :model do
  before(:all) do
    @laptop = FactoryBot.create :device_category, :laptop
    @phone = FactoryBot.create :device_category, :phone
    @tablet = FactoryBot.create :device_category, :tablet
    @monitor = FactoryBot.create :device_category, :monitor
  end
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

  describe 'Get list device category' do
    it 'should return all device category' do
      device_categories = DeviceCategory.all_categories
      expect(device_categories.ids).to include(@laptop.id)
      expect(device_categories.ids).to include(@phone.id)
      expect(device_categories.ids).to include(@tablet.id)
      expect(device_categories.ids).to include(@monitor.id)
    end
  end
end
