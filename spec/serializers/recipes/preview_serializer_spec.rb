require 'rails_helper'

RSpec.describe 'Recipes::PreviewSerializer' do
  let(:recipes) { create_list(:recipe, 12) }

  let(:subject) { Recipes::PreviewSerializer.new(recipes) }

  let(:attributes_to_serialize) do
    %i[id title image calories categories complexity time_consuming]
  end

  describe '#as_json' do
    it 'returns correct json' do
      recipe_json = recipes.map { |model| model.as_json(only: attributes_to_serialize) }

      expect(subject.as_json).to eq(recipe_json)
    end
  end
end
