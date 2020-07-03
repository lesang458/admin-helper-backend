require 'rails_helper'

RSpec.describe PermissionRequest, type: :service do
  before(:all) { User.delete_all }
  describe 'permissions' do
    it 'should not return data' do
      @employee = FactoryBot.create(:user, email: 'employee@gmail.com')
      expect do
        PermissionRequest.new(@employee, 'employees', 'index')
      end.to raise_error ExceptionHandler::Forbidden
    end

    it 'should return data with roles is admin' do
      @admin = FactoryBot.create(:user, :admin, email: 'admin@gmail.com')
      expect do
        PermissionRequest.new(@admin, 'employees', 'index')
      end.not_to raise_error
    end

    it 'should return data with roles is admin' do
      @super_admin = FactoryBot.create(:user, :super_admin, email: 'super_admin@gmail.com')
      expect do
        PermissionRequest.new(@super_admin, 'employees', 'index')
      end.not_to raise_error
    end
  end
end
