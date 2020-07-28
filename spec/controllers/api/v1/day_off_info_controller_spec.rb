require 'rails_helper'

RSpec.describe Api::V1::DayOffInfoController, type: :controller do
  before(:all) do
    User.delete_all
    DayOffCategory.delete_all
    DayOffInfo.delete_all

    @admin = FactoryBot.create(:user, :admin, first_name: 'admin', last_name: 'user')
    @employee = FactoryBot.create(:user, first_name: 'employee', last_name: 'user', roles: ['EMPLOYEE'])

    @category_vacation = FactoryBot.create(:day_off_category, :vacation)
    @category_illness = FactoryBot.create(:day_off_category, :illness)

    @info_vacation = FactoryBot.create(:day_off_info, :vacation)
  end

  describe 'PUT# day-off-info' do
    let!(:update_params) { { id: @info_vacation.id, day_off_category_id: @category_vacation.id, hours: 160 } }
    let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
    let!(:valid_headers) { { authorization: valid_token } }
    let!(:invalid_token) { SecureRandom.hex(64) }
    let!(:invalid_headers) { { authorization: invalid_token } }
    before(:each) { request.headers.merge! valid_headers }

    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      put :update, params: update_params
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      valid_token = JwtToken.encode({ user_id: @employee.id })
      valid_headers = { authorization: valid_token }
      request.headers.merge! valid_headers
      put :update, params: update_params
      expect(response.status).to eq(403)
    end

    it 'should return 200' do
      put :update, params: update_params
      @info_vacation.reload
      expect(response.status).to eq(200)
      expect(@info_vacation.hours).to eq(160)
      expect(@info_vacation.day_off_category_id).to eq(@category_vacation.id)
    end

    it 'should return 404 with fake param id' do
      params = update_params.dup
      params[:id] = 'fake id'
      put :update, params: params
      expect(response.status).to eq(404)
    end

    it 'should return 422 with invalid hours' do
      params = update_params.dup
      params[:hours] = -160
      put :update, params: params
      expect(response.status).to eq(422)
    end

    it 'should return 422 with invalid day_off_category_id' do
      params = update_params.dup
      params[:day_off_category_id] = 'invalid day_off_category_id'
      put :update, params: params
      expect(response.status).to eq(422)
    end
  end
end
