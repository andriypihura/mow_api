require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let!(:user) { create(:user) }
  let!(:recipe) { create(:recipe) }
  let!(:likes) { create_list(:like, 10) }
  let(:like_id) { likes.first.id }
  let(:like) { likes.first }

  describe "GET /likes" do
    before { get '/likes' }

    it 'returns likes' do

      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /likes/:id
  describe 'GET /likes/:id' do
    before { get "/likes/#{like_id}" }

    context 'when the record exists' do
      it 'returns the like' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(like_id)
        expect(json['user_id']).to eq(like.user.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:like_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Like/)
      end
    end
  end

  # Test suite for POST /likes
  describe 'POST /likes' do
    # valid payload
    let(:valid_attributes) { { value: true, user_id: user.id, recipe_id: recipe.id } }

    context 'when the request is valid' do
      before { post '/likes', params: valid_attributes }

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
      before { post '/likes', params: { value: false, user_id: user.id, recipe_id: recipe.id } }

      it 'change the like' do
        expect(json['value']).to eq(false)
        expect(json['user_id']).to eq(user.id)
        expect(json['recipe_id']).to eq(recipe.id)
      end
    end

    context 'when the request is invalid' do
      before { post '/likes', params: { value: true } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/must exist/)
      end
    end
  end

  # Test suite for PUT /likes/:id
  describe 'PUT /likes/:id' do
    let(:valid_attributes) { { value: false } }

    context 'when the record exists' do
      before { put "/likes/#{like_id}", params: valid_attributes }

      it 'updates the record' do
        expect(json['value']).to eq(false)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /likes/:id
  describe 'DELETE /likes/:id' do
    before { delete "/likes/#{like_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
