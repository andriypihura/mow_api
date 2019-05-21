class Api::V1::FilterController < ApplicationController
  skip_before_action :authenticate_request

  # GET /filrer(:params)
  def filter
    results = model.filter_by(filter_params)
                   .paginate(page: params[:page], per_page: 20)
    json_response(
      recipes: model_serializer.new(results).as_json,
      pageCount: results.total_pages
    )
  end

  private

  def model
    models = {
      'Recipe' => Recipe,
      'Menu' => Menu
    }
    models[params[:filter_by]]
  end

  def model_serializer
    model_serializers = {
      'Recipe' => Recipes::PreviewSerializer,
      'Menu' => Menus::IndexSerializer
    }
    model_serializers[params[:filter_by]]
  end

  def filter_params
    params.permit(:title,
                  :time_consuming_from,
                  :time_consuming_to,
                  :calories_from,
                  :calories_to,
                  :complexity)
  end
end
