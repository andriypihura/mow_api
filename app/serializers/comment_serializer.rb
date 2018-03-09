class CommentSerializer

  def initialize(model)
    @model = model
  end

  def as_json
    @model.as_json(only: attributes, include: incl_attributes)
  end

  private

  def attributes
    %i[id message created_at]
  end

  def incl_attributes
    {
      user: {
        only: %i[name avatar_url]
      }
    }
  end
end
