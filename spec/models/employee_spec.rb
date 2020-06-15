require 'rails_helper'

RSpec.describe Employee, type: :model do
  before(:all) do
    Employee.delete_all
    FactoryBot.create(:employee, first_name: 'Le', last_name: 'Diem', birthday: '1995-10-30', joined_company_date: '2015-11-24')
    FactoryBot.create(:employee, first_name: 'Nguyen', last_name: 'An', birthday: '1997-10-30', joined_company_date: '2017-11-24')
    FactoryBot.create(:employee, first_name: 'Dao', last_name: 'Huong', birthday: '1999-10-30', joined_company_date: '2019-11-24')
    @employee = FactoryBot.create(:employee, birthday: '1999-10-04', joined_company_date: '2020-01-24', phone_number: '0935208940')
    FactoryBot.create(:employee, first_name: 'Tao', last_name: 'Quyen', birthday: '1998-05-27', joined_company_date: '2019-09-22')
    FactoryBot.create(:employee, first_name: 'Ho', last_name: 'Trieu', birthday: '1995-12-30', joined_company_date: '2015-12-24', status: 'FORMER')
  end

  describe 'search' do
    it 'should birthday >= 1995-10-30 and birthday <= 1999-10-30' do
      employees = Employee.search({ birthday_from: '1995-10-30', birthday_to: '1999-10-30' })
      expect(employees.count).to eq(6)
      expect(employees.ids).to include @employee.id
    end

    it 'should joined company date >= 2015-11-24 and joined company date <= 2020-01-24' do
      employees = Employee.search({ joined_company_date_from: '2015-11-24', joined_company_date_to: '2020-01-24' })
      expect(employees.count).to eq(6)
      expect(employees.ids).to include @employee.id
    end

    it 'should count to eq 5 with search bithday, joined_company_date, status' do
      employees = Employee.search({ birthday_from: '1995-10-30', birthday_to: '1999-10-30', joined_company_date_from: '2015-11-24', joined_company_date_to: '2020-01-24', status: 'ACTIVE' })
      expect(employees.count).to eq(5)
      expect(employees.ids).to include @employee.id
    end

    it 'should count eq 2 with birthday from and joined_company_date_to' do
      employees = Employee.search({ birthday_from: '1992-10-30', joined_company_date_to: '2019-01-24', status: 'ACTIVE' })
      expect(employees.count).to eq(2)
      expect(employees.ids).to_not include @employee.id
    end

    it 'should count eq 2 with birthday to and joined_company_date_from' do
      employees = Employee.search({ birthday_to: '1998-10-30', joined_company_date_from: '2017-01-24', status: 'ACTIVE' })
      expect(employees.count).to eq(2)
      expect(employees.ids).to_not include @employee.id
    end

    it 'should count eq 5 with status' do
      employees = Employee.search({ status: 'ACTIVE' })
      expect(employees.count).to eq(5)
      expect(employees.ids).to include @employee.id
    end

    it 'should count eq 1 with birthday_to and joined_company_date_from and status' do
      employees = Employee.search({ birthday_to: '1998-10-30', joined_company_date_from: '2015-01-24', status: 'FORMER' })
      expect(employees.count).to eq(1)
      expect(employees.ids).to_not include @employee.id
    end

    it 'should return employee in list employees with search first name' do
      employees = Employee.search({ search: 'tra' })
      expect(employees.count).to eq(1)
      expect(employees.ids).to include @employee.id
    end

    it 'should return employee in list employees with search last name' do
      employees = Employee.search({ search: 'hu' })
      expect(employees.count).to eq(2)
      expect(employees.ids).to include @employee.id
    end

    it 'should return employee in list employees with search phone_number' do
      employees = Employee.search({ search: '0935' })
      expect(employees.count).to eq(1)
      expect(employees.ids).to include @employee.id
    end

    it 'should return employee not in list employees' do
      employees = Employee.search({ search: 'false' })
      expect(employees.count).to eq(0)
      expect(employees.ids).not_to include @employee.id
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

  describe 'relation between employee and user' do
    it { should belong_to(:user) }
  end
end
