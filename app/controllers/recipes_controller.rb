class RecipesController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show, :filter]
  before_action :find_current_user, only: [:show]
  before_action :set_recipe, only: [:show, :update, :destroy]
  before_action :set_user, only: [:create]
  before_action :has_access?, only: [:update]

  # GET /recipes
  def index
    @recipes = Recipe.for_all.paginate(page: params[:page], per_page: 12)

    json_response(recipes: Recipes::PreviewSerializer.new(@recipes).as_json)
  end

  # GET /recipes/overview
  def overview
    @recipes = Recipe.by_type(params[:type], current_user&.id).paginate(page: params[:page], per_page: 20)

    json_response(recipes: Recipes::PreviewSerializer.new(@recipes).as_json)
  end

  # GET /recipes/1
  def show
    if @recipe.public? || current_user == @recipe.user
      json_response(recipe: Recipes::ShowSerializer.new(@recipe, current_user).as_json)
    else
      json_response({ error: 'Forbidden' }, 403)
    end
  end

  # POST /recipes
  def create
    @recipe = @user.recipes.new(recipe_params)

    if @recipe.save
      json_response(recipe: Recipes::ShowSerializer.new(@recipe, current_user).as_json)
    else
      json_response @recipe.errors, :unprocessable_entity
    end
  end

  # PATCH/PUT /recipes/1
  def update
    if recipe_params[:visibility].present? && !current_user.admin?
      params.delete :visibility
    end

    if current_user == @recipe.user || current_user.admin?
      if @recipe.update(recipe_params)
        json_response(recipe: Recipes::ShowSerializer.new(@recipe, current_user).as_json)
      else
        json_response @recipe.errors, :unprocessable_entity
      end
    else
      json_response({error: 'Not Authorized'}, 401)
    end
  end

  # DELETE /recipes/1
  def destroy
    if current_user.admin?
      MenuItem.where(recipe_id: @recipe.id).each do |menu_item|
        recipe = Recipe.new(@recipe)
        recipe.user = menu_item.menu.user
        recipe.visibility = 'for_self'
        recipe.save
        menu_item.update(recipe_id: recipe.id)
      end
      @recipe.destroy
    else
      json_response({ error: 'Forbidden' }, 403)
    end
  end

  # GET /recipes/filrer(:params)
  def filter
    recipes = Recipe.filter_by(filter_params).paginate(page: params[:page], per_page: 20)
    json_response(recipes: Recipes::PreviewSerializer.new(recipes).as_json, pageCount: recipes.total_pages)
  end

  private

  def has_access?
    json_response({ error: 'Forbidden' }, 403) unless current_user == @recipe.user || current_user.admin?
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def filter_params
    params.permit(:title,
                  :time_consuming_from,
                  :time_consuming_to,
                  :calories_from,
                  :calories_to,
                  :complexity)
  end

  def recipe_params
    params.permit(:user_id,
                  :title,
                  :image,
                  :text,
                  :ingredients,
                  :complexity,
                  :categories,
                  :calories,
                  :time_consuming,
                  :visibility)
  end
end
