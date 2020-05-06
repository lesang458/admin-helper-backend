require 'rails_helper'

RSpec.describe Api::V1::EmployeesController, type: :controller do
  let!(:employees) { FactoryBot.create_list(:employee, 50) }
  describe 'GET#list employees non params' do
    before { get(:index) }
    it 'should get list of users' do
      expect(response.status).to eq(200)
    end
    it 'should pass with my input' do
      json_response = JSON.parse(response.body)['pagination']
      expect(json_response['current_page']).to eq(1)
      expect(json_response['page_size']).to eq(20)
      expect(json_response['total_pages']).to eq(3)
      expect(json_response['total_count']).to eq(50)
    end
  end

  describe 'GET#list employees non params' do
    before { get :index, params: { per_page: 3, page: 3 } }
    it 'should get list of users' do
      expect(response.status).to eq(200)
    end
    it 'should pass with my input' do
      json_response = JSON.parse(response.body)['pagination']
      expect(json_response['current_page']).to eq(3)
      expect(json_response['page_size']).to eq(3)
      expect(json_response['total_pages']).to eq(17)
      expect(json_response['total_count']).to eq(50)
    end
  end
end
