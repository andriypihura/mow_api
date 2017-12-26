require 'rails_helper'

RSpec.describe "MenuItems", type: :request do
  let!(:recipe) { create(:recipe) }
  let!(:menu_item) { create(:menu_item) }
  let!(:menu_item_id) { menu_item.id }
  let!(:menu) { menu_item.menu }
  let!(:user) { menu.user }
  let!(:token) do
    post '/authenticate', params: { email: user.email, password: '12345678' }
    json['auth_token']
  end

  describe "GET /users/:user_id/menus/:menu_id/menu_items" do
    before { get "/users/#{user.id}/menus/#{menu.id}/menu_items", params: {}, headers: { 'Authorization' => token } }

    it 'returns menu_items' do

      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /users/:user_id/menus/:menu_id/menu_items/:id
  describe 'GET /users/:user_id/menus/:menu_id/menu_items/:id' do
    before { get "/users/#{user.id}/menus/#{menu.id}/menu_items/#{menu_item_id}", params: {}, headers: { 'Authorization' => token } }

    context 'when the record exists' do
      it 'returns the menu_item' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(menu_item_id)
        expect(json['menu_id']).to eq(menu_item.menu.id)
        expect(json['recipe_id']).to eq(menu_item.recipe.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:menu_item_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find MenuItem/)
      end
    end
  end

  # Test suite for POST /users/:user_id/menus/:menu_id/menu_items
  describe 'POST /users/:user_id/menus/:menu_id/menu_items' do
    # valid payload
    let(:valid_attributes) { { primary_label: "Ttttttt sssss", menu_id: menu.id, recipe_id: recipe.id } }

    context 'when the request is valid' do
      before { post "/users/#{user.id}/menus/#{menu.id}/menu_items", params: valid_attributes, headers: { 'Authorization' => token } }

      it 'creates a menu_item' do
        expect(json['primary_label']).to eq("Ttttttt sssss")
        expect(json['menu_id']).to eq(menu.id)
        expect(json['recipe_id']).to eq(recipe.id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/users/#{user.id}/menus/#{menu.id}/menu_items", params: { primary_label: "Ttttttt sssss" }, headers: { 'Authorization' => token } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/must exist/)
      end
    end
  end

  # Test suite for PUT /users/:user_id/menus/:menu_id/menu_items/:id
  describe 'PUT /users/:user_id/menus/:menu_id/menu_items/:id' do
    let(:valid_attributes) { { primary_label: "updated primary_label" } }

    context 'when the record exists' do
      before { put "/users/#{user.id}/menus/#{menu.id}/menu_items/#{menu_item_id}", params: valid_attributes, headers: { 'Authorization' => token } }

      it 'updates the record' do
        expect(json['primary_label']).to eq("updated primary_label")
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /users/:user_id/menus/:menu_id/menu_items/:id
  describe 'DELETE /users/:user_id/menus/:menu_id/menu_items/:id' do
    before { delete "/users/#{user.id}/menus/#{menu.id}/menu_items/#{menu_item_id}", params: {}, headers: { 'Authorization' => token } }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
