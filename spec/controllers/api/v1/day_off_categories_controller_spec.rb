require 'rails_helper'

RSpec.describe Api::V1::DayOffCategoriesController, type: :controller do
  before(:all) do
    DayOffRequest.delete_all
    User.delete_all
    DayOffCategory.delete_all
    DayOffInfo.delete_all

    @admin = FactoryBot.create(:user, :admin, first_name: 'admin', last_name: 'user')
    @employee = FactoryBot.create(:user, first_name: 'employee', last_name: 'user', roles: ['EMPLOYEE'])
    @category_vacation = FactoryBot.create(:day_off_category, :vacation)
    @category_illness = FactoryBot.create(:day_off_category, :illness)
  end

  let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
  let!(:valid_headers) { { authorization: "Bearer #{valid_token}" } }
  let!(:invalid_token) { SecureRandom.hex(64) }
  let!(:invalid_headers) { { authorization: "Bearer #{invalid_token}" } }
  before(:each) { request.headers.merge! valid_headers }

  describe 'GET# day-off-categories' do
    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      get :index
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      valid_token = JwtToken.encode({ user_id: @employee.id })
      valid_headers = { authorization: "Bearer #{valid_token}" }
      request.headers.merge! valid_headers
      get :index
      expect(response.status).to eq(403)
    end

    it 'should return 200' do
      get :index
      day_off_categories = JSON.parse(response.body)['day_off_categories']
      vacation = day_off_categories.first
      illness = day_off_categories.second
      expect(vacation['name']).to eq(@category_vacation.name)
      expect(vacation['total_hours_default']).to eq(@category_vacation.total_hours_default)
      expect(illness['name']).to eq(@category_illness.name)
      expect(illness['total_hours_default']).to eq(@category_illness.total_hours_default)
      expect(response.status).to eq(200)
    end
  end

  let!(:patch_params) { { id: @category_vacation.id, name: 'ILLNESS', description: 'Hello', total_hours_default: 16 } }

  describe 'PATCH# day-off-category' do
    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      patch :update, params: patch_params
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      valid_token = JwtToken.encode({ user_id: @employee.id })
      valid_headers = { authorization: "Bearer #{valid_token}" }
      request.headers.merge! valid_headers
      patch :update, params: patch_params
      expect(response.status).to eq(403)
    end

    it 'should return 422 with name' do
      params = patch_params.dup
      params[:name] = 'ILLNESS'
      patch :update, params: params
      expect(response.status).to eq(422)
    end

    it 'should return 422 with description' do
      params = patch_params.dup
      params[:description] = 'ok'
      patch :update, params: params
      expect(response.status).to eq(422)
    end

    it 'should return 422 with total_hours_default' do
      params = patch_params.dup
      params[:total_hours_default] = -1
      patch :update, params: params
      expect(response.status).to eq(422)
    end

    it 'should return 200' do
      DayOffCategory.destroy @category_illness.id
      patch :update, params: patch_params
      expect(response.status).to eq(200)
    end
  end
end
