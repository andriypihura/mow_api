require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let!(:recipe) { create(:recipe) }
  let!(:user) { create(:user) }
  let!(:like) { create(:like) }
  let(:like_id) { like.id }
  let!(:token) do
    post '/authenticate', params: { email: user.email, password: '12345678' }
    json['auth_token']
  end

  # Test suite for POST /likes
  describe 'POST /likes' do
    # valid payload
    let(:valid_attributes) { { value: true, user_id: user.id, recipe_id: recipe.id } }

    context 'when the request is valid' do
      before { post '/likes', params: valid_attributes, headers: { 'Authorization' => token } }

      it 'creates a like' do
        expect(json['value']).to eq(true)
        expect(json['user_id']).to eq(user.id)
        expect(json['recipe_id']).to eq(recipe.id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the like already exist' do
      let!(:like_owner_token) do
        post '/authenticate', params: { email: like.user.email, password: '12345678' }
        json['auth_token']
      end

      before { post '/likes', params: { value: true, user_id: like.user.id, recipe_id: like.recipe.id }, headers: { 'Authorization' => like_owner_token } }

      it 'change the like' do
        expect(json['value']).to eq(false)
        expect(json['user_id']).to eq(like.user.id)
        expect(json['recipe_id']).to eq(like.recipe.id)
      end
    end

    context 'when the request is invalid' do
      before { post '/likes', params: { value: true }, headers: { 'Authorization' => token } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/must exist/)
      end
    end
  end

  # Test suite for DELETE /likes/:id
  describe 'DELETE /likes/:id' do
    before { delete "/likes/#{like_id}", headers: { 'Authorization' => token } }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
