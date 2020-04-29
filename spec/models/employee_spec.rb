require 'rails_helper'

RSpec.describe Employee, type: :model do
  before { @employee = FactoryBot.create :employee }
  subject { @employee }
  describe 'first name' do
    it { should respond_to(:first_name) }
    it { should allow_value('MyString').for(:first_name) }
    it { should allow_value('My String').for(:first_name) }
    it 'should be greater or equal 2 and less than or equal 20' do
      should validate_length_of(:first_name).is_at_least(2).is_at_most(20)
    end
    it 'should presence' do
      should validate_presence_of(:first_name)
    end
  end

  describe 'last name' do
    it { should respond_to(:last_name) }
    it { should allow_value('MyString').for(:last_name) }
    it { should allow_value('My String').for(:last_name) }
    it 'should be greater or equal 2 and less than or equal 75' do
      should validate_length_of(:last_name).is_at_least(2).is_at_most(20)
    end
    it 'should presence' do
      should validate_presence_of(:last_name)
    end
  end

  describe 'status' do
    it 'test status should presence' do
      should validate_presence_of(:status)
    end
  end

  describe 'relation between employee and user' do
    it { should belong_to(:user).dependent(:destroy) }
  end
end
