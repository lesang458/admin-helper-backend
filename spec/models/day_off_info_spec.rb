require 'rails_helper'

RSpec.describe DayOffInfo, type: :model do
  before(:all) do
    DayOffInfo.delete_all
    DayOffCategory.delete_all
    User.delete_all
    @user = FactoryBot.create(:user, first_name: 'dang', last_name: 'hanh', birthdate: '1995-12-01', join_date: '2015-12-01')

    @day_off_category_vacation = FactoryBot.create(:day_off_category, :day_off_category_vacation)
    @day_off_category_illness = FactoryBot.create(:day_off_category, :day_off_category_illness)

    @day_off_info_vacation = FactoryBot.create(:day_off_info, :day_off_info_vacation)
    @day_off_info_illness = FactoryBot.create(:day_off_info, :day_off_info_illness)
  end

  it 'should return user_id eq first user id ' do
    expect(@day_off_info_vacation.user_id).to eq(@user.id)
  end

  it 'should return user_id eq first user id ' do
    expect(@day_off_info_illness.user_id).to eq(@user.id)
  end

  it 'should return day_off_category have name VACATION' do
    vacation = DayOffCategory.find(@day_off_info_vacation.day_off_categories_id)
    expect(vacation.name).to eq('VACATION')
  end

  it 'should return day_off_category have name ILLNESS' do
    illness = DayOffCategory.find(@day_off_info_illness.day_off_categories_id)
    expect(illness.name).to eq('ILLNESS')
  end

  describe 'hours' do
    it { should respond_to(:hours) }
    it { should allow_value(123).for(:hours) }
    it { should_not allow_value(-123).for(:hours) }
  end
end
