require 'rails_helper'

RSpec.describe DayOffRequest, type: :model do
  describe 'hours per day' do
    it { should respond_to(:hours_per_day) }
    it { should allow_value(123).for(:hours_per_day) }
    it { should_not allow_value(0).for(:hours_per_day) }
    it { should_not allow_value(-123).for(:hours_per_day) }
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
