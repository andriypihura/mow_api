require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:recipe) { create(:recipe) }
  let!(:comments) { create_list(:comment, 10) }
  let(:comment_id) { comments.first.id }
  let(:comment) { comments.first }

  describe "GET /comments" do
    before { get '/comments' }

    it 'returns comments' do

      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /comments/:id
  describe 'GET /comments/:id' do
    before { get "/comments/#{comment_id}" }

    context 'when the record exists' do
      it 'returns the comment' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(comment_id)
        expect(json['user_id']).to eq(comment.user.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:comment_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Comment/)
      end
    end
  end

  # Test suite for POST /comments
  describe 'POST /comments' do
    # valid payload
    let(:valid_attributes) { { message: "Ttttttt sssss", user_id: user.id, recipe_id: recipe.id } }

    context 'when the request is valid' do
      before { post '/comments', params: valid_attributes }

      it 'creates a comment' do
        expect(json['message']).to eq("Ttttttt sssss")
        expect(json['user_id']).to eq(user.id)
        expect(json['recipe_id']).to eq(recipe.id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/comments', params: { message: "Ttttttt sssss" } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/must exist/)
      end
    end
  end

  # Test suite for PUT /comments/:id
  describe 'PUT /comments/:id' do
    let(:valid_attributes) { { message: "updated message" } }

    context 'when the record exists' do
      before { put "/comments/#{comment_id}", params: valid_attributes }

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
    before { delete "/comments/#{comment_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
