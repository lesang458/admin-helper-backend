require 'rails_helper'

RSpec.describe DayOffInfo, type: :model do
  before(:all) do
    DayOffRequest.delete_all
    User.delete_all
    DayOffInfo.delete_all
    DayOffCategory.delete_all
    @user = FactoryBot.create(:user, :employee)

    FactoryBot.create(:day_off_category, :vacation)
    FactoryBot.create(:day_off_category, :illness)

    @info_vacation = FactoryBot.create(:day_off_info, :vacation)
    FactoryBot.create(:day_off_request, user: @user, day_off_info: @info_vacation, from_date: '2020-07-07', to_date: '2020-07-20')
    FactoryBot.create(:day_off_request, user: @user, day_off_info: @info_vacation, from_date: '2020-07-20', to_date: '2020-07-24')
    @info_illness = FactoryBot.create(:day_off_info, :illness)
    FactoryBot.create(:day_off_request, user: @user, day_off_info: @info_illness, from_date: '2020-07-07', to_date: '2020-07-20')
    FactoryBot.create(:day_off_request, user: @user, day_off_info: @info_illness, from_date: '2020-07-20', to_date: '2020-07-24')
  end

  describe 'hours off availability' do
    it 'should return number hours off availability with info_vacation' do
      available_hours = @info_vacation.available_hours
      expect(available_hours).to eq(@info_vacation.hours - @info_vacation.day_off_requests.sum(&:total_hours_off))
    end

    it 'should return number hours off availability with info_illness' do
      available_hours = @info_illness.available_hours
      expect(available_hours).to eq(@info_vacation.hours - @info_illness.day_off_requests.sum(&:total_hours_off))
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
end
