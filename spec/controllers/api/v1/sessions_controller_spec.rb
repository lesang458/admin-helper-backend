require 'rails_helper'

RSpec.describe Api::V1::SessionsController do
  describe 'Success Sessions' do
    before(:each) do
      @user = FactoryBot.create :user
      post :create, params: { email: @user.email, password: '123456' }
    end

    it 'should response 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'Failed Sessions' do
    before(:each) do
      @user = FactoryBot.create :user
      post :create, params: { email: @user.email, password: 'wrong password' }
    end

    it 'should response 422' do
      expect(response).to have_http_status(422)
    end
  end
end
