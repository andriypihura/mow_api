class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :show]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :has_access?, only: [:update, :destroy]

  # GET /users/1
  def show
    json_response @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      json_response @user, :created
    else
      json_response @user.errors, :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      json_response @user
    else
      json_response @user.errors, :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    if current_user.admin?
      @user.destroy
    else
      json_response({ error: 'Forbidden' }, 403)
    end
  end

  private

  def has_access?
    json_response({ error: 'Forbidden' }, 403) unless current_user == @user || current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :roles)
  end
end
