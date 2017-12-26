class MenusController < ApplicationController
  before_action :set_menu, only: [:show, :update, :destroy]
  before_action :set_user
  before_action :has_access?

  # GET /users/1/menus
  def index
    @menus = Menu.all

    json_response @menus
  end

  # GET /users/1/menus/1
  def show
    json_response @menu
  end

  # POST /users/1/menus
  def create
    @menu = Menu.new(menu_params)

    if @menu.save
      json_response @menu, :created
    else
      json_response @menu.errors, :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1/menus/1
  def update
    if @menu.update(menu_params)
      json_response @menu
    else
      json_response @menu.errors, :unprocessable_entity
    end
  end

  # DELETE /users/1/menus/1
  def destroy
    @menu.destroy
  end

  private

  def has_access?
    json_response({ error: 'Forbidden' }, 403) unless current_user == @user || current_user.admin?
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_menu
    @menu = Menu.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def menu_params
    params.permit(:title, :user_id)
  end
end
