require 'rails_helper'

RSpec.describe "Menus", type: :request do
  let!(:menu) { create(:menu) }
  let!(:user) { create(:user) }
  let(:menu_id) { menu.id }

  describe "GET /menus" do
    before { get '/menus' }

    it 'returns menus' do

      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /menus/:id
  describe 'GET /menus/:id' do
    before { get "/menus/#{menu_id}" }

    context 'when the record exists' do
      it 'returns the menu' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(menu_id)
        expect(json['user_id']).to eq(menu.user.id)
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

  # Test suite for POST /menus
  describe 'POST /menus' do
    # valid payload
    let(:valid_attributes) { { title: "Ttttttt sssss", user_id: user.id } }

    context 'when the request is valid' do
      before { post '/menus', params: valid_attributes }

      it 'creates a menu' do
        expect(json['title']).to eq("Ttttttt sssss")
        expect(json['user_id']).to eq(user.id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/menus', params: { title: "Ttttttt sssss" } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/must exist/)
      end
    end
  end

  # Test suite for PUT /menus/:id
  describe 'PUT /menus/:id' do
    let(:valid_attributes) { { title: "updated title" } }

    context 'when the record exists' do
      before { put "/menus/#{menu_id}", params: valid_attributes }

      it 'updates the record' do
        expect(json['title']).to eq("updated title")
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /menus/:id
  describe 'DELETE /menus/:id' do
    before { delete "/menus/#{menu_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
