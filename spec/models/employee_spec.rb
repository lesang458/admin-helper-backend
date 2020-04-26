require "rails_helper"

RSpec.describe Employee, type: :model do
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should allow_value("MyString").for(:first_name) }
  it { should allow_value("My String").for(:first_name) }
  it { should allow_value("MyString").for(:last_name) }
  it { should allow_value("My String").for(:last_name) }
  before { @employee = FactoryBot.create :employee }
  subject { @employee }
  describe " test length of first name and last name in (2..75)" do
    it { should belong_to(:user).dependent(:destroy) }
    it {
      should_not validate_inclusion_of(:first_name).
                   in_range(2..75)
      should_not validate_inclusion_of(:last_name).
                   in_range(2..75)
    }
  end
  describe "test validate attribute should presence " do
    it do
      should validate_presence_of(:first_name)
      should validate_presence_of(:last_name)
      should validate_presence_of(:status)
    end
  end
end
