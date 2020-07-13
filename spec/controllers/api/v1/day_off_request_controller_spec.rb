require 'rails_helper'

RSpec.describe Api::V1::DayOffRequestController, type: :controller do
  before(:all) do
    User.delete_all
    DayOffInfo.delete_all
    DayOffRequest.delete_all
    DayOffCategory.delete_all
    @day_off_category = FactoryBot.create(:day_off_category, :day_off_category_vacation)
    @admin = FactoryBot.create(:user, :admin)
    @day_off_info = FactoryBot.create(:day_off_info, :day_off_info_vacation)
  end

  describe 'Create day off request success' do
    let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
    let!(:valid_headers) { { authorization: valid_token } }
    before(:each) { request.headers.merge! valid_headers }
    it 'should return 201 ' do
      post :create, params: { from_date: Time.now, to_date: Time.now, hours_per_day: 4,
                              notes: 'ok', id: @admin.id, day_off_info_id: @day_off_info.id }
      expect(response.status).to eq(201)
    end
  end

  describe 'Create day off with request failed' do
    let!(:valid_token) { JwtToken.encode({ user_id: @admin.id }) }
    let!(:valid_headers) { { authorization: valid_token } }
    before(:each) { request.headers.merge! valid_headers }
    it 'should return 422 with from date or to date empty' do
      post :create, params: { from_date: '', to_date: '', hours_per_day: 4,
                              notes: 'ok', id: @admin.id, day_off_info_id: @day_off_info.id }
      expect(response.status).to eq(422)
    end

    it 'should return 422 with hours per day < 0' do
      post :create, params: { from_date: Time.now, to_date: Time.now, hours_per_day: -1,
                              notes: 'ok', id: @admin.id, day_off_info_id: @day_off_info.id }
      expect(response.status).to eq(422)
    end

    it 'should return 422' do
      post :create, params: { from_date: Time.now, to_date: Time.now, hours_per_day: 4,
                              notes: 'ok', id: @admin.id }
      expect(response.status).to eq(422)
    end
  end
end
