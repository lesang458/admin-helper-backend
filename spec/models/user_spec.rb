require 'rails_helper'
RSpec.describe User, type: :model do
  before { FactoryBot.create(:user) }
  before { @user = FactoryBot.build(:user) }
  subject {
    @user
  }

  it { should respond_to(:email) }
  it { should respond_to(:encrypted_password) }
  it { should allow_value('valid@gmail.com').for(:email) }
  it { should_not allow_value('invalid.gmail.com').for(:email) }
end
