require 'rails_helper'
RSpec.describe Api::V1::PasswordController do
  before(:all) do
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
      get :valid_token?, params: { email: @user.email, token: @user.reset_password_token }
      expect(response.status).to eq(200)
    end

    it 'should return 400 with invalid token' do
      post :create, params: { email: @user.email }
      @user.reload
      get :valid_token?, params: { email: @user.email, token: '404notfound' }
      expect(response.status).to eq(400)
    end

    it 'should return 400 with invalid token' do
      post :create, params: { email: @user.email }
      @user.reload
      @user.reset_password_sent_at -= 15.minutes
      @user.save
      get :valid_token?, params: { email: @user.email, token: @user.reset_password_token }
      expect(response.status).to eq(400)
    end
  end

  describe 'password' do
    it 'shouldreturn 200 with params new password empty' do
      post :create, params: { email: @user.email }
      @user.reload
      put :update, params: { id: @user.id, email: @user.email, token: @user.reset_password_token, new_password: '' }
      expect(response.status).to eq(400)
    end

    it 'should return 200 with params new password presence' do
      post :create, params: { email: @user.email }
      @user.reload
      put :update, params: { id: @user.id, email: @user.email, token: @user.reset_password_token, new_password: '123456789' }
      expect(response.status).to eq(200)
    end

    it 'should return 401 with params new password presence and invalid token' do
      post :create, params: { email: @user.email }
      @user.reload
      put :update, params: { id: @user.id, email: @user.email, token: '404notfound', new_password: '123456789' }
      expect(response.status).to eq(401)
    end
  end
end
