class CommentsController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :set_recipe, only: [:create]

  # GET /comments
  def index
    @comments = Comment.all

    json_response @comments
  end

  # GET /comments/1
  def show
    json_response @comment
  end

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
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_recipe
      @recipe = Recipe.find(params[:recipe_id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.permit(:message, :user_id)
    end
end
