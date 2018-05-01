module Recipes
  class ShowSerializer

    def initialize(model, current_user)
      @model = model
      @user = current_user
    end

    def as_json
      @model
        .as_json(only: attributes,
                 methods: mth_attributes,
                 include: incl_attributes)
        .merge(
          comments: comments,
          liked: @model.liked_by_user(@user)
        )
    end

    private

    def attributes
      %i[id title image text ingredients calories
         categories complexity visibility time_consuming created_at]
    end

    def incl_attributes
      {
        user: {
          only: %i[id name avatar_url]
        }
      }
    end

    def mth_attributes
      %i[likes_count]
    end

    def comments
      @model.comments.map { |comment| CommentSerializer.new(comment).as_json }
    end
  end
end
