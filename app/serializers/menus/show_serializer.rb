module Menus
  class ShowSerializer

    def initialize(model)
      @model = model
    end

    def as_json
      @model
        .as_json(only: attributes)
        .merge(
          menu_items: menu_items
        )
    end

    private

    def attributes
      %i[id title created_at updated_at color calories visibility]
    end

    def menu_items
      @model.menu_items.map { |menu_item| MenuItemSerializer.new(menu_item).as_json }
    end
  end
end
