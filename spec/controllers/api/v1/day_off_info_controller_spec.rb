require 'rails_helper'

RSpec.describe Api::V1::DayOffInfoController, type: :controller do
  before(:all) do
    DeviceHistory.delete_all
    User.delete_all
    DayOffCategory.delete_all
    DayOffInfo.delete_all
    @admin = FactoryBot.create(:user, :admin, first_name: 'admin', last_name: 'user')
    @employee = FactoryBot.create(:user, first_name: 'employee', last_name: 'user', roles: ['EMPLOYEE'])

    @category_vacation = FactoryBot.create(:day_off_category, :vacation)
    @category_illness = FactoryBot.create(:day_off_category, :illness)

    @info_vacation = FactoryBot.create(:day_off_info, :vacation, user: @admin)
  end

  describe 'PUT# day-off-info' do
    let!(:update_params) { { id: @info_vacation.id, day_off_category_id: @category_vacation.id, hours: 160 } }
    let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
    let!(:valid_headers) { { authorization: "Bearer #{valid_token}" } }
    let!(:invalid_token) { SecureRandom.hex(64) }
    let!(:invalid_headers) { { authorization: "Bearer #{invalid_token}" } }
    let!(:get_params) { { user_id: @admin.id, day_off_category_id: @category_vacation.id } }
    before(:each) { request.headers.merge! valid_headers }

    describe 'PATCH# Deactive' do
      let!(:patch_params_status) { { id: @info_vacation.id } }
      it 'return status 401 status code with invalid token' do
        request.headers.merge! invalid_headers
        patch :deactivate, params: patch_params_status
        expect(response.status).to eq(401)
      end

      it 'should return 403 with employee' do
        employee_token = JwtToken.encode({ user_id: @employee.id })
        headers = { authorization: "Bearer #{employee_token}" }
        request.headers.merge! headers
        patch :deactivate, params: patch_params_status
        expect(response.status).to eq(403)
      end

      it 'should return 404' do
        patch :deactivate, params: { id: 'NOT FOUND' }
        expect(response.status).to eq(404)
      end

      it 'should return 200' do
        patch :deactivate, params: patch_params_status
        @info_vacation.reload
        expect(@info_vacation.status).to eq 'inactive'
        expect(response.status).to eq(200)
      end

      it 'should return 400 if day off category was deactivated' do
        patch :deactivate, params: patch_params_status
        patch :deactivate, params: patch_params_status
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to include 'Day off info was deactivated'
      end
    end

    describe 'Get Day Off Info' do
      it 'should return 401' do
        request.headers.merge! invalid_headers
        get :index, params: get_params
        expect(response.status).to eq(401)
      end

      it 'should return 403 with employee' do
        valid_token = JwtToken.encode({ user_id: @employee.id })
        valid_headers = { authorization: "Bearer #{valid_token}" }
        request.headers.merge! valid_headers
        get :index, params: get_params
        expect(response.status).to eq(403)
      end

      it 'should return 200' do
        get :index, params: get_params
        expect(response.status).to eq(200)
        json_response = JSON.parse(response.body)['meta']
        expect(json_response['current_page']).to eq(1)
        expect(json_response['page_size']).to eq(1)
        expect(json_response['total_pages']).to eq(1)
        expect(json_response['total_count']).to eq(1)
      end
    end

    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      put :update, params: update_params
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      valid_token = JwtToken.encode({ user_id: @employee.id })
      valid_headers = { authorization: "Bearer #{valid_token}" }
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
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Hours must be greater than or equal to 0'
      expect(response.status).to eq(422)
    end

    it 'should return 422 with unexist day_off_category_id' do
      params = update_params.dup
      params[:day_off_category_id] = 'unexist day_off_category_id'
      put :update, params: params
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Day off category must exist'
      expect(response.status).to eq(422)
    end
  end
end
