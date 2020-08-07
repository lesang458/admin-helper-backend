require 'rails_helper'

RSpec.describe DeviceHistory, type: :model do
  before(:all) do
    DeviceHistory.delete_all
    Device.delete_all
    DeviceCategory.delete_all
    @phone = FactoryBot.create(:device_category, :phone)
    @iphone = FactoryBot.create(:device, :iphone, device_category: @phone)
    @admin = FactoryBot.create(:user, :admin)
    @employee = FactoryBot.create(:user, :employee)
    @device_history = FactoryBot.create(:device_history, from_date: '2020-07-15', to_date: '2020-07-31', status: 'IN_INVENTORY', device: @iphone)
    FactoryBot.create(:device_history, from_date: '2020-07-31', to_date: '2020-08-15', status: 'ASSIGNED', device: @iphone, user: @employee)
  end
  describe 'from date' do
    it { should respond_to(:from_date) }
    it { should validate_presence_of(:from_date) }
    it { should allow_value('2020-12-12').for(:from_date) }
    it { should_not allow_value('2020').for(:from_date) }
  end

  describe 'to date' do
    it { should respond_to(:from_date) }
    it { should allow_value('2020-12-12').for(:to_date) }
    it { should allow_value('').for(:to_date) }
    it { should_not validate_presence_of(:to_date) }
  end

  describe 'status' do
    it { should respond_to(:status) }
    it { should allow_value('DISCARDED').for(:status) }
    it { should allow_value('ASSIGNED').for(:status) }
    it { should allow_value('IN_INVENTORY').for(:status) }
    it { should_not allow_value('').for(:status) }
    it 'should raise error with invald status' do
      expect { FactoryBot.build(:device_history, status: :invalid_status) }
        .to raise_error(ArgumentError)
    end
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

  let!(:request_params) { { user_id: @employee.id, device_category_id: @phone.id, from_date: '2020-07-10', to_date: '2020-07-20', status: 'IN_INVENTORY' } }
  describe 'GET device history' do
    it 'ID must be in the list with vacation and from date, to date' do
      device_histories = DeviceHistory.search(request_params)
      devices = DeviceCategory.find(request_params[:device_category_id]).devices
      expect(device_histories.map(&:device_id).uniq).to eq(devices.map(&:user_id).compact)
      expect(device_histories.ids).not_to include @device_history.id
    end

    it 'ID must be in the list with vacation and to date' do
      params = request_params.dup
      params.delete(:from_date)
      params.delete(:user_id)
      device_histories = DeviceHistory.search(params)
      devices = DeviceCategory.find(request_params[:device_category_id]).devices
      expect(device_histories.map(&:device_id).uniq).to eq(devices.map(&:id))
      expect(device_histories.ids).to include @device_history.id
    end

    it 'ID must be in the list with vacation and to date' do
      params = request_params.dup
      params.delete(:from_date)
      params.delete(:user_id)
      params[:status] = 'ASSIGNED'
      device_histories = DeviceHistory.search(params)
      devices = DeviceCategory.find(request_params[:device_category_id]).devices
      expect(device_histories.map(&:device_id).uniq).to eq(devices.map(&:id))
      expect(device_histories.ids).to_not include @device_history.id
    end
  end
end
