require 'rails_helper'

RSpec.describe 'CommentSerializer' do
  let(:comment) { create(:comment) }

  let(:subject) { CommentSerializer.new(comment) }

  let(:attributes_to_serialize) do
    %i[id message created_at]
  end

  let(:incl_attributes_to_serialize) do
    {
      user: {
        only: %i[name avatar_url]
      }
    }
  end

  describe '#as_json' do
    it 'returns correct json' do
      comment_json = comment.as_json(only: attributes_to_serialize,
                                     include: incl_attributes_to_serialize)

      expect(subject.as_json).to eq(comment_json)
    end
  end
end
