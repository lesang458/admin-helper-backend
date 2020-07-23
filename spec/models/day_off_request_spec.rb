require 'rails_helper'

RSpec.describe DayOffRequest, type: :model do
  before(:all) do
    DayOffRequest.delete_all
    DayOffInfo.delete_all
    DayOffCategory.delete_all
    @admin = FactoryBot.create(:user, :admin)
    @vacation = FactoryBot.create(:day_off_category, :vacation)
    @illness = FactoryBot.create(:day_off_category, :illness)
    @vacation_info = FactoryBot.create(:day_off_info, :vacation)
    @illness_info = FactoryBot.create(:day_off_info, :illness)
    @day_off_request = FactoryBot.create(:day_off_request, user: @admin, day_off_info: @vacation_info, from_date: '2020-07-07', to_date: '2020-07-20')
    FactoryBot.create(:day_off_request, user: @admin, day_off_info: @vacation_info, from_date: '2020-07-07', to_date: '2020-07-20')
    FactoryBot.create(:day_off_request, user: @admin, day_off_info: @illness_info, from_date: '2020-07-20', to_date: '2020-07-24')
  end
  describe 'hours per day' do
    it { should respond_to(:hours_per_day) }
    it { should allow_value(123).for(:hours_per_day) }
    it { should_not allow_value(0).for(:hours_per_day) }
    it { should_not allow_value(-123).for(:hours_per_day) }
  end

  let!(:request_params) { { id: @admin.id, day_off_category_id: @vacation.id, from_date: '2020-07-10', to_date: '2020-07-15' } }
  describe 'GET history day off request' do
    it 'ID must be in the list with vacation and from date, to date' do
      day_off_requests = DayOffRequest.search(request_params)
      expect(day_off_requests.map(&:user_id).uniq).to eq([request_params[:id]])
      expect(day_off_requests.ids).to include @day_off_request.id
    end

    it 'ID must be in the list with vacation and to date' do
      params = request_params.dup
      params.delete(:from_date)
      day_off_requests = DayOffRequest.search(params)
      expect(day_off_requests.map(&:user_id).uniq).to eq([request_params[:id]])
      expect(day_off_requests.ids).to include @day_off_request.id
    end

    it 'ID must be in the list with vacation and from date' do
      params = request_params.dup
      params.delete(:to_date)
      day_off_requests = DayOffRequest.search(params)
      expect(day_off_requests.map(&:user_id).uniq).to eq([request_params[:id]])
      expect(day_off_requests.ids).to include @day_off_request.id
    end

    it 'ID must not be in the list with from date and to date' do
      params = request_params.dup
      params[:from_date] = '2020-07-01'
      params[:to_date] = '2020-07-06'
      day_off_request = DayOffRequest.search(params)
      expect(day_off_request.ids).to_not include @day_off_request.id
    end

    it 'ID must not be in the list with from date and to date' do
      params = request_params.dup
      params[:day_off_category_id] = @illness.id
      day_off_request = DayOffRequest.search(params)
      expect(day_off_request.ids).to_not include @day_off_request.id
    end
  end

  describe 'from date' do
    it 'should presence' do
      should validate_presence_of(:from_date)
    end
  end

  describe 'to date' do
    it 'should presence' do
      should validate_presence_of(:from_date)
    end
  end

  describe DayOffRequest do
    it { should belong_to(:day_off_info) }
    it { should belong_to(:user) }
  end

  describe DayOffInfo do
    it { should have_many(:day_off_requests) }
  end

  describe User do
    it { should have_many(:day_off_requests) }
  end
end
