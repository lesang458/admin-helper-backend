require 'rails_helper'

RSpec.describe DayOffCategory, type: :model do
  describe 'name' do
    it { should respond_to(:name) }
    it { should allow_value('PASS').for(:name) }
    it { should_not allow_value('').for(:name) }
  end

  describe 'status' do
    it { should respond_to(:status) }
    it { should allow_value('ACTIVE').for(:status) }
    it { should allow_value('INACTIVE').for(:status) }
    it { should_not allow_value('').for(:status) }
  end

  describe 'description' do
    it { should respond_to(:description) }
    it { should allow_value('description').for(:description) }
    it { should allow_value('hi').for(:description) }
    it 'should have length shorter than or equal to 225' do
      should validate_length_of(:description).is_at_most(225)
    end
  end

  describe 'total_hours_default' do
    it { should respond_to(:total_hours_default) }
    it { should allow_value(2).for(:total_hours_default) }
    it { should_not allow_value(0).for(:total_hours_default) }
  end

  describe DayOffCategory do
    it { should have_many(:day_off_infos) }
    it { should have_many(:day_off_requests) }
  end
end
