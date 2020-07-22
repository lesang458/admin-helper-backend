require 'rails_helper'
require 'google/apis/oauth2_v2'
RSpec.describe Api::V1::SessionsController do
  describe 'Success Sessions' do
    before(:each) do
      @user = FactoryBot.create(:user)
    end

    it 'should response 200 ' do
      post :create, params: { email: @user.email, password: '123456' }
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

  describe 'login via google email' do
    before(:each) do
      @user = FactoryBot.create :user
    end

    it 'should response 200 with valid email' do
      allow(GoogleApis::OAuth2).to receive(:get_access_token).and_return(@user)
      get :google_login, params: { provider: 'google_oauth2' }
      expect(response).to have_http_status(200)
    end

    it 'should response 400 invalid email' do
      @user.email = 'fake@email.com'
      allow(GoogleApis::OAuth2).to receive(:get_access_token).and_return(@user)
      get :google_login, params: { provider: 'google_oauth2' }
      expect(response).to have_http_status(400)
    end
  end
end
