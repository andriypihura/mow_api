require 'rails_helper'

RSpec.describe 'Menus::ShowSerializer' do
  let(:menu) { create(:menu) }

  let(:subject) { Menus::ShowSerializer.new(menu) }
  let(:menu_items) { menu.menu_items.map { |menu_item| MenuItemSerializer.new(menu_item).as_json } }

  let(:attributes_to_serialize) do
    %i[id title created_at updated_at color]
  end

  describe '#as_json' do
    it 'returns correct json' do
      menu_json = menu.as_json(only: attributes_to_serialize)
                      .merge(menu_items: menu_items)

      expect(subject.as_json).to eq(menu_json)
    end
  end
end
