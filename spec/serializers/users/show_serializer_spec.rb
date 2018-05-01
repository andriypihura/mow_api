require 'rails_helper'

RSpec.describe 'Menus::ShowSerializer' do
  let(:user) { create(:user) }

  let(:subject) { Users::ShowSerializer.new(user) }

  let(:attributes_to_serialize) do
    %i[id name created_at updated_at avatar_url email roles]
  end

  describe '#as_json' do
    it 'returns correct json' do
      user_json = user.as_json(only: attributes_to_serialize)

      expect(subject.as_json).to eq(user_json)
    end
  end
end
