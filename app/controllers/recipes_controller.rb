class RecipesController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]
  before_action :set_recipe, only: [:show, :update, :destroy]
  before_action :set_user, only: [:create]
  before_action :has_access?, only: [:update]
  before_action :upload_image, only: [:create, :update]

  # GET /recipes
  def index
    @recipes = Recipe.all.paginate(page: params[:page], per_page: 12)

    json_response @recipes
  end

  # GET /recipes/1
  def show
    if @recipe.public? || current_user == @recipe.user
      json_response @recipe
    else
      json_response({ error: 'Forbidden' }, 403)
    end
  end

  # POST /recipes
  def create
    @recipe = @user.recipes.new(@recipe_params)
    binding.pry
    if @recipe.save
      json_response @recipe, :created
    else
      json_response @recipe.errors, :unprocessable_entity
    end
  end

  # PATCH/PUT /recipes/1
  def update
    if current_user == @recipe.user ||  current_user.admin?
      if @recipe.update(@recipe_params)
        json_response @recipe
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

  private

  def upload_image
    @recipe_params = recipe_params
    @recipe_params.delete(:visibility) if @recipe_params[:visibility].present? && !current_user.admin?
    @recipe_params[:image] = Cloudinary::Uploader.upload(recipe_params[:image])['url'] if recipe_params[:image]
  end

  def has_access?
    json_response({ error: 'Forbidden' }, 403) unless current_user == @recipe.user || current_user.admin?
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
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
