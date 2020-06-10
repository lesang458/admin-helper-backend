require 'rails_helper'
RSpec.describe Api::V1::SessionsController do
  describe 'Success Sessions' do
    before(:each) do
      @user = FactoryBot.create :user
      @employee = FactoryBot.create :employee
    end

    it 'should response 200' do
      post :create, params: { email: @employee.user.email, password: '123456' }
      expect(response).to have_http_status(200)
    end
  end

  describe 'Failed Sessions' do
    before(:each) do
      @user = FactoryBot.create :user
    end

    it 'should response 400' do
      post :create, params: { email: 'unexist@gmail.com', password: '123456' }
      expect(response).to have_http_status(400)
    end

    it 'should response 400' do
      post :create, params: { email: @user.email, password: 'wrong password' }
      expect(response).to have_http_status(400)
    end
  end
end
