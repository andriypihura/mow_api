require 'rails_helper'

RSpec.describe 'Menus::ShowSerializer' do
  let(:menus) { create_list(:menu, 10) }

  let(:subject) { Menus::IndexSerializer.new(menus) }

  let(:attributes_to_serialize) do
    %i[id title created_at updated_at color]
  end

  describe '#as_json' do
    it 'returns correct json' do
      menu_json = menus.map { |model| model.as_json(only: attributes_to_serialize) }

      expect(subject.as_json).to eq(menu_json)
    end
  end
end
