require 'rails_helper'

RSpec.describe 'Menus::ShowSerializer' do
  let(:menu) { create(:menu) }

  let(:subject) { Menus::ShowSerializer.new(menu) }

  let(:attributes_to_serialize) do
    %i[id title created_at updated_at color]
  end

  let(:incl_attributes_to_serialize) do
    {
      menu_items: {
        only: %i[id primary_label secondary_label created_at],
        include: {
          recipe: {
            only: %i[id title image calories categories complexity time_consuming ingredients]
          }
        }
      }
    }
  end

  describe '#as_json' do
    it 'returns correct json' do
      menu_json = menu.as_json(only: attributes_to_serialize,
                               include: incl_attributes_to_serialize)

      expect(subject.as_json).to eq(menu_json)
    end
  end
end
