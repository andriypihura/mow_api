class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :has_access?, only: [:update, :destroy]
  before_action :upload_avatar, only: [:update]

  # GET /users/1
  def show
    if current_user.id == params[:id].to_i
      json_response(user: Users::ShowSerializer.new(@user).as_json)
    else
      json_response({ error: 'Forbidden' }, 403)
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      json_response({ user: Users::ShowSerializer.new(@user).as_json }, :created)
    else
      json_response @user.errors, :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(@user_params)
      json_response(user: Users::ShowSerializer.new(@user).as_json)
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

  def upload_avatar
    @user_params = user_params
    @user_params[:avatar_url] = Cloudinary::Uploader.upload(user_params[:avatar_url])['url'] if user_params[:avatar_url]
  end

  def has_access?
    json_response({ error: 'Forbidden' }, 403) unless current_user == @user || current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:name, :avatar_url, :email, :password, :password_confirmation, :roles)
  end
end
