require 'rails_helper'
RSpec.describe User, type: :model do
  before(:all) do
    DayOffRequest.delete_all
    User.delete_all
    @user = FactoryBot.create(:user, first_name: 'Tran', last_name: 'Huy', birthdate: '1995-12-01', join_date: '2015-12-01')
    FactoryBot.create(:user, first_name: 'Le', last_name: 'Diem', birthdate: '1995-10-30', join_date: '2015-11-24')
    FactoryBot.create(:user, first_name: 'Nguyen', last_name: 'An', birthdate: '1997-10-30', join_date: '2017-11-24')
    FactoryBot.create(:user, first_name: 'Dao', last_name: 'Huong', birthdate: '1999-10-30', join_date: '2019-11-24')
    FactoryBot.create(:user, birthdate: '1999-10-04', join_date: '2020-01-24', phone_number: '0935208940')
    FactoryBot.create(:user, first_name: 'Tao', last_name: 'Quyen', birthdate: '1998-05-27', join_date: '2019-09-22')
    FactoryBot.create(:user, first_name: 'Ho', last_name: 'Trieu', birthdate: '1995-12-30', join_date: '2015-12-24', status: 'FORMER')
  end

  it { should respond_to(:email) }
  it { should respond_to(:encrypted_password) }
  it { should allow_value('valid@gmail.com').for(:email) }
  it { should_not allow_value(' ').for(:email) } # Empty
  it { should_not allow_value('@gmail.com').for(:email) } # Missing username
  it { should_not allow_value('invalidgmail.com').for(:email) } # Missing @
  it { should_not allow_value('invalid@').for(:email) } # Missing domain
  it { should_not allow_value('invalidgmailcom').for(:email) } # just string
  it { should_not allow_value('#@%^%#$@#$@#.com').for(:email) } # Garbage
  it { should_not allow_value('email@domain@domain.com').for(:email) } # Two @ sign
  it { should_not allow_value('&#12354;&#12356;&#12358;&#12360;&#12362;@domain.com').for(:email) } # Unicode char as address
  it { should_not allow_value('email@domain.com (Joe Smith)').for(:email) } # Text followed email is not allowed
  it { should_not allow_value('email@domain').for(:email) } # Missing top level domain (.com/.net/.org/etc)
  it { should_not allow_value('email@111.222.333.44444').for(:email) } # Invalid IP format

  describe 'search' do
    it 'should birthday >= 1995-10-30 and birthday <= 1999-10-30' do
      users = User.search({ birthday_from: '1995-10-30', birthday_to: '1999-10-30' })
      expect(users.count).to eq(7)
      expect(users.ids).to include @user.id
    end

    it 'should joined company date >= 2015-11-24 and joined company date <= 2020-01-24' do
      users = User.search({ joined_company_date_from: '2015-11-24', joined_company_date_to: '2020-01-24' })
      expect(users.count).to eq(7)
      expect(users.ids).to include @user.id
    end

    it 'should count to eq 6 with search bithday, joined_company_date, status' do
      users = User.search({ birthday_from: '1995-10-30', birthday_to: '1999-10-30', joined_company_date_from: '2015-11-24', joined_company_date_to: '2020-01-24', status: 'ACTIVE' })
      expect(users.count).to eq(6)
      expect(users.ids).to include @user.id
    end

    it 'should count eq 3 with birthday from and joined_company_date_to' do
      users = User.search({ birthday_from: '1992-10-30', joined_company_date_to: '2019-01-24', status: 'ACTIVE' })
      expect(users.count).to eq(3)
      expect(users.ids).to include @user.id
    end

    it 'should count eq 2 with birthday to and joined_company_date_from' do
      users = User.search({ birthday_to: '1998-10-30', joined_company_date_from: '2017-01-24', status: 'ACTIVE' })
      expect(users.count).to eq(2)
      expect(users.ids).to_not include @user.id
    end

    it 'should count eq 5 with status' do
      users = User.search({ status: 'ACTIVE' })
      expect(users.count).to eq(6)
      expect(users.ids).to include @user.id
    end

    it 'should count eq 1 with birthday_to and joined_company_date_from and status' do
      users = User.search({ birthday_to: '1998-10-30', joined_company_date_from: '2015-01-24', status: 'FORMER' })
      expect(users.count).to eq(1)
      expect(users.ids).to_not include @user.id
    end

    it 'should return employee in list employees with search first name' do
      users = User.search({ search: 'tra' })
      expect(users.count).to eq(1)
      expect(users.ids).to include @user.id
    end

    it 'should return employee in list employees with search last name' do
      users = User.search({ search: 'hu' })
      expect(users.count).to eq(2)
      expect(users.ids).to include @user.id
    end

    it 'should return employee in list employees with search phone_number' do
      users = User.search({ search: '0935' })
      expect(users.count).to eq(1)
      expect(users.ids).to_not include @user.id
    end

    it 'should return employee not in list employees' do
      users = User.search({ search: 'false' })
      expect(users.count).to eq(0)
      expect(users.ids).not_to include @user.id
    end
  end

  describe 'phone_number' do
    it { should respond_to(:phone_number) }
    it { should allow_value('123456789').for(:phone_number) }
    it { should_not allow_value('12345678900987654321123456').for(:phone_number) }
    it 'should lenght less than or equal 25' do
      should validate_length_of(:phone_number).is_at_most(25)
    end
    it { should allow_value(nil).for(:phone_number) }
  end

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
end
