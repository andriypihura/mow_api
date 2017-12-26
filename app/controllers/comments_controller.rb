class CommentsController < ApplicationController
  before_action :set_recipe
  before_action :set_comment, only: [:update, :destroy]
  before_action :has_access?, only: [:update, :destroy]

  # POST /comments
  def create
    @comment = @recipe.comments.new(comment_params)

    if @comment.save
      json_response @comment, :created
    else
      json_response @comment.errors, :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      json_response @comment
    else
      json_response @comment.errors, :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
  end

  private

  def has_access?
    json_response({ error: 'Forbidden' }, 403) unless current_user == @comment.user || current_user.admin?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = @recipe.comments.find(params[:id])
  end

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.permit(:message, :user_id, :recipe_id)
  end
end
