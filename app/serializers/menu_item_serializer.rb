class MenuItemSerializer

  def initialize(model)
    @model = model
  end

  def as_json
    @model.as_json(only: attributes, include: incl_attributes)
  end

  private

  def attributes
    %i[id primary_label secondary_label created_at]
  end

  def incl_attributes
    {
      recipe: {
        only: %i[id title image calories categories complexity time_consuming ingredients]
      }
    }
  end
end
