require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:comment) { create(:comment) }
  let!(:recipe) { comment.recipe }
  let!(:user) { comment.user }
  let!(:token) do
    post '/authenticate', params: { email: user.email, password: '12345678' }
    json['auth_token']
  end

  # Test suite for POST /recipes/#{recipe_id}/comments
  describe 'POST recipes/:recipe_id/comments' do
    # valid payload
    let(:valid_attributes) { { message: "Test message", user_id: user.id } }

    context 'when the request is valid' do
      before { post "/recipes/#{recipe.id}/comments", params: valid_attributes, headers: { 'Authorization' => token } }

      it 'creates a comment' do
        expect(json['message']).to eq("Test message")
        expect(json['user']['name']).to eq(user.name)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/recipes/#{recipe.id}/comments", params: {}, headers: { 'Authorization' => token } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/can't be blank/)
      end
    end
  end

  # Test suite for PUT /comments/:id
  describe 'PUT /comments/:id' do
    let(:valid_attributes) { { message: "updated message" } }

    context 'when the record exists' do
      before { put "/recipes/#{recipe.id}/comments/#{comment.id}", params: valid_attributes, headers: { 'Authorization' => token } }

      it 'updates the record' do
        expect(json['message']).to eq("updated message")
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /comments/:id
  describe 'DELETE /comments/:id' do
    before { delete "/recipes/#{recipe.id}/comments/#{comment.id}", params: {}, headers: { 'Authorization' => token } }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
