module Menus
  class IndexSerializer

    def initialize(models)
      @models = models
    end

    def as_json
      @models.map { |model| model.as_json(only: attributes) }
    end

    private

    def attributes
      %i[id title created_at updated_at color]
    end
  end
end
