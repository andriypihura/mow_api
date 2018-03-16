module Recipes
  class PreviewSerializer

    def initialize(models)
      @models = models
    end

    def as_json
      @models.map { |model| model.as_json(only: attributes) }
    end

    private

    def attributes
      %i[id title image calories categories complexity time_consuming]
    end
  end
end
