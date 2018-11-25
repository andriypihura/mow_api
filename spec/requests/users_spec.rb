require 'rails_helper'
require 'jwt'

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user) }
  let!(:user_id) { user.id }
  let!(:token) do
    post '/api/v1/authenticate', params: { email: user.email, password: '12345678' }
    json['auth_token']
  end

  # Test suite for GET /users/:id
  describe 'GET /users/:id' do
    before do
      get "/api/v1/users/#{user_id}", params: {}, headers: { 'Authorization' => token }
    end

    context 'when the record exists' do
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['user']['id']).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:user_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  # Test suite for POST /users
  describe 'POST /users' do
    let(:valid_attributes) { { name: 'Test User name', email: 'email@mail.com', password: '12345678', password_confirmation: '12345678' } }

    context 'when the request is valid' do
      before { post '/api/v1/users', params: valid_attributes }

      it 'creates a user' do
        expect(json['user']['name']).to eq('Test User name')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/users', params: { name: user.name } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/has already been taken/)
      end
    end
  end

  # Test suite for PUT /users/:id
  describe 'PUT /users/:id' do
    let(:valid_attributes) { { name: 'New User name' } }

    context 'when the record exists' do
      before { put "/api/v1/users/#{user_id}", params: valid_attributes, headers: { 'Authorization' => token } }

      it 'updates the record' do
        expect(json['user']['name']).to eq('New User name')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /users/:id
  describe 'DELETE /users/:id' do

    context 'when current_user admin' do
      let!(:admin) { create(:user, :admin) }

      before do
        post '/api/v1/authenticate', params: { email: admin.email, password: '12345678' }
        admin_token = json['auth_token']
        delete "/api/v1/users/#{user_id}", params: {}, headers: { 'Authorization' => admin_token }
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when current_user not admin' do

      before do
        delete "/api/v1/users/#{user_id}", params: {}, headers: { 'Authorization' => token }
      end

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end
end
