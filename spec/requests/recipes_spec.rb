require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  let!(:user) { create(:user) }
  let!(:recipes) { create_list(:recipe, 10) }
  let(:recipe_id) { recipes.first.id }
  let!(:token) do
    post '/authenticate', params: { email: user.email, password: '12345678' }
    json['auth_token']
  end

  describe "GET /recipes" do
    before { get '/recipes?page=1' }

    it 'returns recipes' do
      expect(json).not_to be_empty
      expect(json['recipes'].size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /recipes/:id
  describe 'GET /recipes/:id' do
    let!(:public_recipe) { create(:recipe, :public) }

    context 'when the record exists' do
      before do
        get "/recipes/#{public_recipe.id}"
      end

      it 'returns the recipe' do
        expect(json).not_to be_empty
        expect(json['recipe']['id']).to eq(public_recipe.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:recipe_id) { 1000 }

      before do
        get "/recipes/#{recipe_id}"
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Recipe/)
      end
    end
  end

  # Test suite for POST /recipes
  describe 'POST /recipes' do
    context 'when the request is valid' do
      let!(:valid_attributes) do
        {
          title: 'Learn Elm',
          user_id: user.id,
          ingredients: 'la,la,la',
          text: '322'
        }
      end
      before { post '/recipes', params: valid_attributes, headers: { 'Authorization' => token } }

      it 'creates a recipe' do
        expect(json['recipe']['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/recipes', params: { user_id: user.id }, headers: { 'Authorization' => token } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/can't be blank/)
      end
    end
  end

  # Test suite for PUT /recipes/:id
  describe 'PUT /recipes/:id' do
    let!(:user_recipe) { create(:recipe) }
    let(:valid_attributes) { { title: 'Shopping' } }

    context 'when the record exists' do
      before do
        post '/authenticate', params: { email: user_recipe.user.email, password: '12345678' }
        put "/recipes/#{user_recipe.id}", params: valid_attributes, headers: { 'Authorization' => json['auth_token'] }
      end

      it 'updates the record' do
        expect(json['recipe']['title']).to eq('Shopping')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /recipes/:id
  describe 'DELETE /recipes/:id' do
    let!(:admin) { create(:user, :admin) }

    before do
      post '/authenticate', params: { email: admin.email, password: '12345678' }
      admin_token = json['auth_token']
      delete "/recipes/#{recipe_id}", params: {}, headers: { 'Authorization' => admin_token }
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
