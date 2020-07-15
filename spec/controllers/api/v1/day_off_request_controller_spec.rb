require 'rails_helper'

RSpec.describe Api::V1::DayOffRequestController, type: :controller do
  before(:all) do
    DayOffCategory.delete_all
    @day_off_category = FactoryBot.create(:day_off_category, :vacation)
    @admin = FactoryBot.create(:user, :admin)
    @employee = FactoryBot.create(:user, :employee)
    @day_off_info = FactoryBot.create(:day_off_info, :vacation)
  end

  let!(:request_params) { { from_date: Time.now, to_date: Time.now, hours_per_day: 4, notes: 'ok', id: @admin.id, day_off_info_id: @day_off_info.id } }
  let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
  let!(:valid_headers) { { authorization: valid_token } }
  let!(:invalid_token) { JwtToken.encode({ user_id: @employee.id }) }
  let!(:invalid_headers) { { authorization: invalid_token } }
  before(:each) { request.headers.merge! valid_headers }

  describe 'Create day off request success' do
    it 'should return 201 ' do
      post :create, params: request_params
      expect(response.status).to eq(201)
    end
  end

  describe 'Create day off with request failed' do
    it 'should return 422 with from date or to date empty' do
      params = request_params.dup
      params[:from_date] = ''
      params[:to_date] = ''
      post :create, params: params
      expect(response.status).to eq(422)
    end

    it 'should return 422 with hours per day < 0' do
      params = request_params.dup
      params[:hours_per_day] = -1
      post :create, params: params
      expect(response.status).to eq(422)
    end

    it 'should return 422' do
      params = request_params.dup
      params.delete(:day_off_info_id)
      post :create, params: params
      expect(response.status).to eq(422)
    end

    it 'should return 403' do
      request.headers.merge! invalid_headers
      post :create, params: request_params
      expect(response.status).to eq(403)
    end
  end
end
