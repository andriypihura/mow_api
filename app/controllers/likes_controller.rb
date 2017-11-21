class LikesController < ApplicationController
  before_action :set_like, only: [:show, :update, :destroy]

  # GET /likes
  def index
    @likes = Like.all

    json_response @likes
  end

  # GET /likes/1
  def show
    json_response @like
  end

  # POST /likes
  def create
    @like = find_by_user_and_recipe_ids(params[:user_id], params[:recipe_id])
    if @like.present?
      redirect_to like_path(method: :put)
    else
      @like = Like.new(like_params)

      if @like.save
        json_response @like, :created
      else
        json_response @like.errors, :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /likes/1
  def update
    if @like.update(like_params)
      json_response @like
    else
      json_response @like.errors, :unprocessable_entity
    end
  end

  # DELETE /likes/1
  def destroy
    @like.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end

    def find_by_user_and_recipe_ids(user_id, recipe_id)
      Like.where(user_id: user_id, recipe_id: recipe_id).first
    end

    # Only allow a trusted parameter "white list" through.
    def like_params
      params.permit(:value, :user_id, :recipe_id)
    end
end
