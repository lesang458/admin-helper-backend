require 'rails_helper'

RSpec.describe Employee, type: :model do
  before(:all) do
    Employee.delete_all
    FactoryBot.create(:employee, first_name: 'aaabbbccc', last_name: 'gmail.com', phone_number: '0935208940')
    FactoryBot.create(:employee, first_name: 'Tu', last_name: 'Quyen', phone_number: '0905123456')
    FactoryBot.create(:employee, first_name: 'Ngoc', last_name: 'Diem', phone_number: '0907567765')
    FactoryBot.create(:employee, first_name: 'Ngoc', last_name: 'An', phone_number: '0817227509')
    @employee = FactoryBot.create(:employee, first_name: 'Tran', last_name: 'Huy', phone_number: '0935270046')
  end
  describe 'sort' do
    it 'should returns sorted employee list with first_name' do
      employees = Employee.sort_by('first_name asc')
      expect(employees.first.first_name).to eq('aaabbbccc')
      expect(employees.second.last_name).to eq('Diem')
      expect(employees.third.last_name).to eq('An')
      expect(employees.fourth).to eq(@employee)
    end

    it 'should returns sorted employee list with last_name' do
      employees = Employee.sort_by('last_name asc')
      expect(employees.first.last_name).to eq('An')
      expect(employees.second.last_name).to eq('Diem')
      expect(employees.third.last_name).to eq('gmail.com')
      expect(employees.fourth).to eq(@employee)
    end

    it 'should returns sorted employee list with last_name and first_name' do
      employees = Employee.sort_by('first_name asc,last_name asc')
      expect(employees.first.first_name).to eq('aaabbbccc')
      expect(employees.second.last_name).to eq('An')
      expect(employees.third.last_name).to eq('Diem')
      expect(employees.fourth).to eq(@employee)
    end
  end

  describe 'search' do
    it 'should return employe in list employees with search first name' do
      employees = Employee.search({ search: 'tra' })
      expect(employees.count).to eq(1)
      expect(employees.ids).to include @employee.id
    end

    it 'should return employe in list employees with search last name' do
      employees = Employee.search({ search: 'hu' })
      expect(employees.count).to eq(1)
      expect(employees.ids).to include @employee.id
    end

    it 'should return employe in list employees with search phone number' do
      employees = Employee.search({ search: '0935' })
      expect(employees.count).to eq(2)
      expect(employees.ids).to include @employee.id
    end

    it 'should return employe not in list employees' do
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
    it 'should presence' do
      should validate_presence_of(:phone_number)
    end
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
