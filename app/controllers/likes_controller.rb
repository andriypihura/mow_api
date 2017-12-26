class LikesController < ApplicationController
  before_action :set_like, only: [:update, :destroy]

  # POST /likes
  def create
    @like = find_by_user_and_recipe_ids(params[:user_id], params[:recipe_id])

    if @like.present? && current_user == @like.user
      update_like
    else
      create_like
    end
  end

  # DELETE /likes/1
  def destroy
    @like.destroy
  end

  private

  def create_like
    @like = Like.new(like_params)

    if @like.save
      json_response @like, :created
    else
      json_response @like.errors, :unprocessable_entity
    end
  end

  def update_like
    if @like.update(value: !@like.value)
      json_response @like
    else
      json_response @like.errors, :unprocessable_entity
    end
  end

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
