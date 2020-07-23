require 'rails_helper'

RSpec.describe Api::V1::DayOffCategoriesController, type: :controller do
  before(:all) do
    User.delete_all
    @admin = FactoryBot.create(:user, :admin, first_name: 'admin', last_name: 'user')
    @employee = FactoryBot.create(:user, first_name: 'employee', last_name: 'user', roles: ['EMPLOYEE'])
  end

  describe 'GET# day-off-categories' do
    let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
    let!(:valid_headers) { { authorization: valid_token } }
    let!(:invalid_token) { SecureRandom.hex(64) }
    let!(:invalid_headers) { { authorization: invalid_token } }
    before(:each) { request.headers.merge! valid_headers }

    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      get :index
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      valid_token = JwtToken.encode({ user_id: @employee.id })
      valid_headers = { authorization: valid_token }
      request.headers.merge! valid_headers
      patch :index
      expect(response.status).to eq(403)
    end

    it 'should return 200' do
      patch :index
      expect(response.status).to eq(200)
    end
  end
end
