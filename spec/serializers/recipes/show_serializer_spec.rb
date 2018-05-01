require 'rails_helper'

RSpec.describe 'Recipes::ShowSerializer' do
  let(:recipe) { create(:recipe) }

  let(:user) { create(:user) }

  let(:comments) { recipe.comments.map { |comment| CommentSerializer.new(comment).as_json } }

  let(:subject) { Recipes::ShowSerializer.new(recipe, user) }

  let(:attributes_to_serialize) do
    %i[id title image text ingredients calories
       categories complexity visibility time_consuming created_at]
  end

  let(:incl_attributes_to_serialize) do
    {
      user: {
        only: %i[name avatar_url]
      }
    }
  end

  let(:mth_attributes_to_serialize) do
    %i[likes_count]
  end

  describe '#as_json' do
    it 'returns correct json' do
      recipe_json = recipe.as_json(only: attributes_to_serialize,
                                   methods: mth_attributes_to_serialize,
                                   include: incl_attributes_to_serialize)
                          .merge(
                            comments: comments,
                            liked: recipe.liked_by_user(user)
                          )

      expect(subject.as_json).to eq(recipe_json)
    end
  end
end
