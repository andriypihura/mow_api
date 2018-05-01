module Users
  class ShowSerializer

    def initialize(model)
      @model = model
    end

    def as_json
      @model
        .as_json(only: attributes)
    end

    private

    def attributes
      %i[id name created_at updated_at avatar_url email roles]
    end
  end
end
