require 'rails_helper'

RSpec.describe DayOffInfo, type: :model do
  before(:all) do
    DayOffInfo.delete_all
    DayOffCategory.delete_all
    User.delete_all
    @user = FactoryBot.create(:user, :employee)

    FactoryBot.create(:day_off_category, :vacation)
    FactoryBot.create(:day_off_category, :illness)

    @info_vacation = FactoryBot.create(:day_off_info, :vacation)
    @info_illness = FactoryBot.create(:day_off_info, :illness)
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
