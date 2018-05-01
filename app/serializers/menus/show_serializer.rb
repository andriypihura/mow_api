module Menus
  class ShowSerializer

    def initialize(model)
      @model = model
    end

    def as_json
      @model
        .as_json(only: attributes,
                 include: incl_attributes)
    end

    private

    def attributes
      %i[id title created_at updated_at color]
    end

    def incl_attributes
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
  end
end
