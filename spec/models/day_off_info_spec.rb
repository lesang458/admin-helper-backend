require 'rails_helper'

RSpec.describe DayOffInfo, type: :model do
  before(:all) do
    DayOffRequest.delete_all
    DeviceHistory.delete_all
    User.delete_all
    DayOffInfo.delete_all
    DayOffCategory.delete_all
    @user = FactoryBot.create(:user, :employee)

    @vacation = FactoryBot.create(:day_off_category, :vacation)
    @illness = FactoryBot.create(:day_off_category, :illness)

    @info_vacation = FactoryBot.create(:day_off_info, :vacation)
    FactoryBot.create(:day_off_request, user: @user, day_off_info: @info_vacation, from_date: '2020-07-07', to_date: '2020-07-20')
    FactoryBot.create(:day_off_request, user: @user, day_off_info: @info_vacation, from_date: '2020-07-21', to_date: '2020-07-24')
    @info_illness = FactoryBot.create(:day_off_info, :illness)
    FactoryBot.create(:day_off_request, user: @user, day_off_info: @info_illness, from_date: '2020-07-07', to_date: '2020-07-20')
    FactoryBot.create(:day_off_request, user: @user, day_off_info: @info_illness, from_date: '2020-07-21', to_date: '2020-07-24')
  end

  describe 'hours off availability' do
    it 'should return number hours off availability with info_vacation' do
      available_hours = @info_vacation.available_hours
      expect(available_hours).to eq(16)
    end

    it 'should return number hours off availability with info_illness' do
      available_hours = @info_illness.available_hours
      expect(available_hours).to eq(16)
    end
  end

  it 'should return user_id eq first user id ' do
    expect(@info_vacation.user_id).to eq(@user.id)
  end

  it 'should return user_id eq first user id ' do
    expect(@info_illness.user_id).to eq(@user.id)
  end

  it 'should return day_off_category have name VACATION' do
    vacation = DayOffCategory.find(@info_vacation.day_off_category_id)
    expect(vacation.name).to eq('VACATION')
  end

  it 'should return day_off_category have name ILLNESS' do
    illness = DayOffCategory.find(@info_illness.day_off_category_id)
    expect(illness.name).to eq('ILLNESS')
  end

  describe 'hours' do
    it { should respond_to(:hours) }
    it { should allow_value(123).for(:hours) }
    it { should_not allow_value(-123).for(:hours) }
  end

  let!(:request_params) { { user_id: User.first, day_off_category_id: @vacation.id } }
  describe do
    it 'ID must be in the list with vacation and user' do
      day_off_infos = DayOffInfo.search(request_params)
      expect(day_off_infos.ids).to include @info_vacation.id
    end

    it 'ID must be in the list with user' do
      params = request_params.dup
      params.delete(:day_off_category_id)
      day_off_infos = DayOffInfo.search(request_params)
      expect(day_off_infos.ids).to include @info_vacation.id
    end

    it 'ID must be in the list with vacation' do
      params = request_params.dup
      params.delete(:user_id)
      day_off_infos = DayOffInfo.search(request_params)
      expect(day_off_infos.ids).to include @info_vacation.id
    end
  end
end
