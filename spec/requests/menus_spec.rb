require 'rails_helper'

RSpec.describe "Menus", type: :request do
  let!(:menu) { create(:menu) }
  let!(:user) { menu.user }
  let(:menu_id) { menu.id }
  let!(:token) do
    post '/authenticate', params: { email: user.email, password: '12345678' }
    json['auth_token']
  end

  describe 'GET /users/:user_id/menus' do
    before { get "/users/#{user.id}/menus", params: {}, headers: { 'Authorization' => token } }

    it 'returns menus' do

      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /users/:user_id/menus/:id
  describe 'GET /users/:user_id/menus/:id' do
    before { get "/users/#{user.id}/menus/#{menu_id}", params: {}, headers: { 'Authorization' => token } }

    context 'when the record exists' do
      it 'returns the menu' do
        expect(json).not_to be_empty
        expect(json['menu']['id']).to eq(menu_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:menu_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Menu/)
      end
    end
  end

  # Test suite for POST /users/:user_id/menus
  describe 'POST /users/:user_id/menus' do
    # valid payload
    let(:valid_attributes) { { title: "Ttttttt sssss" } }

    context 'when the request is valid' do
      before { post "/users/#{user.id}/menus", params: valid_attributes, headers: { 'Authorization' => token } }

      it 'creates a menu' do
        expect(json['title']).to eq("Ttttttt sssss")
        expect(json['user_id']).to eq(user.id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/users/#{user.id}/menus", params: {}, headers: { 'Authorization' => token } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/can't be blank/)
      end
    end
  end

  # Test suite for PUT /users/:user_id/menus/:id
  describe 'PUT /users/:user_id/menus/:id' do
    let(:valid_attributes) { { title: "updated title" } }

    context 'when the record exists' do
      before { put "/users/#{user.id}/menus/#{menu_id}", params: valid_attributes, headers: { 'Authorization' => token } }

      it 'updates the record' do
        expect(json['title']).to eq("updated title")
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /users/:user_id/menus/:id
  describe 'DELETE /users/:user_id/menus/:id' do
    before { delete "/users/#{user.id}/menus/#{menu_id}", params: {}, headers: { 'Authorization' => token } }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
