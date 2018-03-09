module Recipes
  class ShowSerializer

    def initialize(model)
      @model = model
    end

    def as_json
      @model
        .as_json(only: attributes)
        .merge(comments: comments, include: incl_attributes)
    end

    private

    def attributes
      %i[id title image text ingredients
         categories complexity visibility time_consuming created_at]
    end

    def incl_attributes
      {
        user: {
          only: %i[name avatar_url]
        }
      }
    end

    def comments
      @model.comments.map { |comment| CommentSerializer.new(comment).as_json }
    end
  end
end
