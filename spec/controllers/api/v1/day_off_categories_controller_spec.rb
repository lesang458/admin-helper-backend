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

  let!(:admin_token) { JwtToken.encode({ user_id: @admin.id }) }
  let!(:valid_headers) { { authorization: "Bearer #{admin_token}" } }
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
      employee_token = JwtToken.encode({ user_id: @employee.id })
      headers = { authorization: "Bearer #{employee_token}" }
      request.headers.merge! headers
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

  describe 'PATCH# day-off-category' do
    let!(:patch_params) { { id: @category_vacation.id, name: 'ILLNESS', description: 'Hello', total_hours_default: 16 } }
    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      patch :update, params: patch_params
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      employee_token = JwtToken.encode({ user_id: @employee.id })
      headers = { authorization: "Bearer #{employee_token}" }
      request.headers.merge! headers
      patch :update, params: patch_params
      expect(response.status).to eq(403)
    end

    it 'should return 422 with name already in use' do
      params = patch_params.dup
      params[:name] = 'ILLNESS'
      patch :update, params: params
      expect(response.status).to eq(422)
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Name has already been taken'
    end

    it 'should return 422 with too short description' do
      params = patch_params.dup
      params[:description] = 'ok'
      patch :update, params: params
      expect(response.status).to eq(422)
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Description is too short'
    end

    it 'should return 422 with negative total_hours_default' do
      params = patch_params.dup
      params[:total_hours_default] = -1
      patch :update, params: params
      expect(response.status).to eq(422)
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Total hours default must be greater than 0'
    end

    it 'should return 200' do
      DayOffCategory.destroy @category_illness.id
      patch :update, params: patch_params
      @category_vacation.reload
      expect(@category_vacation.name).to eq patch_params[:name]
      expect(@category_vacation.description).to eq patch_params[:description]
      expect(@category_vacation.total_hours_default).to eq patch_params[:total_hours_default]
      expect(response.status).to eq(200)
    end
  end

  describe 'POST# create day-off-category' do
    let!(:post_params) {
      {
        name: 'Summer',
        total_hours_default: 16,
        description: "when don't need go to school"
      }
    }
    it 'return status 401 status code with invalid token' do
      request.headers.merge! invalid_headers
      post :create, params: post_params
      expect(response.status).to eq(401)
    end

    it 'should return 403 with employee' do
      employee_token = JwtToken.encode({ user_id: @employee.id })
      headers = { authorization: "Bearer #{employee_token}" }
      request.headers.merge! headers
      post :create, params: post_params
      expect(response.status).to eq(403)
    end

    it 'should return 422 with name already in use' do
      params = post_params.dup
      params[:name] = 'ILLNESS'
      post :create, params: params
      expect(response.status).to eq(422)
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Name has already been taken'
    end

    it 'should return 422 with too short description' do
      params = post_params.dup
      params[:description] = 'hi'
      post :create, params: params
      expect(response.status).to eq(422)
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Description is too short'
    end

    it 'should return 422 with negative total_hours_default' do
      params = post_params.dup
      params[:total_hours_default] = -1
      post :create, params: params
      expect(response.status).to eq(422)
      message = JSON.parse(response.body)['message']
      expect(message).to include 'Total hours default must be greater than 0'
    end

    it 'should return 201' do
      post :create, params: post_params
      day_off_category = JSON.parse(response.body)['day_off_category']
      expect(day_off_category['name']).to eq post_params[:name]
      expect(day_off_category['description']).to eq post_params[:description]
      expect(day_off_category['total_hours_default']).to eq post_params[:total_hours_default]
      expect(response.status).to eq(201)
    end
  end
end
