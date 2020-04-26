require "rails_helper"
RSpec.describe User, type: :model do
  before { FactoryBot.create(:user) }
  before { @user = FactoryBot.build(:user) }
  subject {
    @user
  }

  it { should respond_to(:email) }
  it { should respond_to(:encrypted_password) }
  it { should allow_value("valid@gmail.com").for(:email) }
  it { should_not allow_value(" ").for(:email) } # Empty
  it { should_not allow_value("@gmail.com").for(:email) } # Missing username
  it { should_not allow_value("invalidgmail.com").for(:email) } # Missing @
  it { should_not allow_value("invalid@").for(:email) } # Missing domain
  it { should_not allow_value("invalidgmailcom").for(:email) } # just string
  it { should_not allow_value('#@%^%#$@#$@#.com').for(:email) } # Garbage
  it { should_not allow_value("email@domain@domain.com").for(:email) } # Two @ sign
  it { should_not allow_value("&#12354;&#12356;&#12358;&#12360;&#12362;@domain.com").for(:email) } # Unicode char as address
  it { should_not allow_value("email@domain.com (Joe Smith)").for(:email) } # Text followed email is not allowed
  it { should_not allow_value("email@domain").for(:email) } # Missing top level domain (.com/.net/.org/etc)
  it { should_not allow_value("email@111.222.333.44444").for(:email) } # Invalid IP format
  it { should have_one(:employee) }
end
