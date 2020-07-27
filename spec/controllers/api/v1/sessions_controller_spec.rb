require 'rails_helper'
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

    let!(:expried_id_token) {
      'eyJhbGciOiJSUzI1NiIsImtpZCI6IjRlNGViZTQ4N2Q1Y2RmMmIwMjZhM2IyMjlkODZmMGQ0MjU4NDQ5ZmUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXpwIjoiNjMyMjQ5ODY5NTk4
      LTZraTRhcW92cHRxcGdsMjNzbHZzcnRyZnQzN21ibXJtLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiNjMyMjQ5ODY5NTk4LTZraTRhcW92cHRxcGdsMjNzbHZzcnRyZnQzN21ibXJtLmFwcHMuZ29vZ2xldXNlcmNvbnRlbn
      QuY29tIiwic3ViIjoiMTAyNDIzOTIzNTMwNDY4NTY5NDc5IiwiaGQiOiJub3ZhaHViLnZuIiwiZW1haWwiOiJoYW5obGVAbm92YWh1Yi52biIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoiZ1V4dnBXUG5OWVpJbHhXSkF5Mmg1
      QSIsImlhdCI6MTU5NTIyNzI2MSwiZXhwIjoxNTk1MjMwODYxfQ.UPJURVTbZJyG99foFH0zXuOBnGEko573vliUSqE07cIQfaOWam-tUQcMwo-RyGbDdlLmutEoTCuMPfN99lDERStp_jWUmmkgFaDZox784-GKSPiPzAlcyLa2AdHVZlb24O3
      FNC80Iw9-MJ9RY3TIEaZDrVruCYfZt9TG6gaabknFwHAqgCJOgniRnS4pFuoDUaoEx4bQo5ZlawLSAFa2gfTA9b_Eatvw4JPygQPO4ieCUZKWe0fmdJqJzVskK5mHzYrilJwY6Dl5OCLu5FVa_JoO8mK7c-ansa3s8wYjlXO8nGwLfktheJvGi
      vkBH8Pk8fuPUjb5h2sRPjnBWJS2uw'
    }

    let!(:invalid_id_token) {
      'INVALID'
    }

    it 'should response 200 with valid email' do
      allow(GoogleApis::IdTokens).to receive(:get_user_info).and_return(@user)
      post :google_login, params: { id_token: 'id token' }
      expect(response).to have_http_status(200)
    end

    it 'should response 400 invalid email' do
      @user.email = 'fake@email.com'
      allow(GoogleApis::IdTokens).to receive(:get_user_info).and_return(@user)
      post :google_login, params: { id_token: 'id token' }
      expect(response).to have_http_status(400)
    end

    it 'should response 401 expried id_token' do
      post :google_login, params: { id_token: expried_id_token }
      expect(response).to have_http_status(401)
    end

    it 'should response 401 invalid id_token' do
      post :google_login, params: { id_token: invalid_id_token }
      expect(response).to have_http_status(401)
    end
  end
end
