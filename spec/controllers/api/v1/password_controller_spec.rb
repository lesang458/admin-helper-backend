require 'rails_helper'
RSpec.describe Api::V1::PasswordController do
  before(:all) do
    DeviceHistory.delete_all
    User.delete_all
    @super_admin = FactoryBot.create(:user, :super_admin, first_name: 'An', last_name: 'da')
    @user = FactoryBot.create(:user, :admin, first_name: 'An', last_name: 'Ba')
  end

  describe 'send mail' do
    it 'should return 200 with valid email' do
      post :create, params: { email: @user.email }
      @user.reload
      expect(response.status).to eq(200)
    end

    it 'should return 200 with invalid email' do
      post :create, params: { email: 'huytran.301099@gmail.com' }
      expect(response.status).to eq(404)
    end
  end

  describe 'token' do
    it 'should return 200 with valid token' do
      post :create, params: { email: @user.email }
      @user.reload
      post :validate_token, params: { email: @user.email, token: @user.reset_password_token }
      expect(response.status).to eq(200)
    end

    it 'should return 401 with invalid token' do
      post :create, params: { email: @user.email }
      @user.reload
      post :validate_token, params: { email: @user.email, token: '404notfound' }
      expect(response.status).to eq(401)
    end

    it 'should return 401 with expired token' do
      post :create, params: { email: @user.email }
      @user.reload
      @user.reset_password_sent_at -= 15.minutes
      @user.save
      post :validate_token, params: { email: @user.email, token: @user.reset_password_token }
      expect(response.status).to eq(401)
    end
  end

  describe 'password' do
    it 'should return 400 with empty password' do
      post :create, params: { email: @user.email }
      @user.reload
      put :update, params: { id: @user.id, email: @user.email, token: @user.reset_password_token, new_password: '' }
      expect(response.status).to eq(400)
    end

    it 'should return 200 with new valid password' do
      post :create, params: { email: @user.email }
      @user.reload
      put :update, params: { id: @user.id, email: @user.email, token: @user.reset_password_token, new_password: '123456789' }
      expect(response.status).to eq(200)
    end

    it 'should return 401 with params new valid password and invalid token' do
      post :create, params: { email: @user.email }
      @user.reload
      put :update, params: { id: @user.id, email: @user.email, token: '404notfound', new_password: '123456789' }
      expect(response.status).to eq(401)
    end
  end
end
