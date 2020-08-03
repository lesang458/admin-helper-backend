require 'rails_helper'

RSpec.describe Device, type: :model do
  before(:all) do
    User.delete_all
    Device.delete_all
    DeviceCategory.delete_all
    @phone = FactoryBot.create(:device_category, :phone)
    @iphone = FactoryBot.create(:device, :iphone, device_category: @phone)
  end

  it { should respond_to(:name) }
  it { should respond_to(:price) }
  it { should respond_to(:description) }

  it { should allow_value('valid name').for(:name) }
  it { should_not allow_value(' ').for(:name) }
  it { should_not allow_value('  ').for(:name) }

  it { should allow_value(1000).for(:price) }
  it { should_not allow_value(-1000).for(:price) }
  it { should_not allow_value(0).for(:price) }

  it { should allow_value('here is description').for(:description) }

  it 'should return device_category_id eq phone id ' do
    expect(@iphone.device_category_id).to eq(@phone.id)
  end
end
