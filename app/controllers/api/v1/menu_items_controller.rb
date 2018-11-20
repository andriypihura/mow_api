class Api::V1::MenuItemsController < ApplicationController
  before_action :set_user
  before_action :set_menu
  before_action :set_menu_item, only: %i[show update destroy]
  before_action :can?

  # GET users/1/menus/1/menu_items
  def index
    @menu_items = @menu.menu_items.all

    json_response @menu_items
  end

  # GET users/1/menus/1/menu_items/1
  def show
    json_response(menu_item: MenuItemSerializer.new(@menu_item).as_json)
  end

  # POST users/1/menus/1/menu_items
  def create
    @menu_item = @menu.menu_items.new(menu_item_params)

    if @menu_item.save
      json_response(
        { menu_item: MenuItemSerializer.new(@menu_item).as_json },
        :created
      )
    else
      json_response @menu_item.errors, :unprocessable_entity
    end
  end

  # PATCH/PUT users/1/menus/1/menu_items/1
  def update
    if @menu_item.update(menu_item_params)
      json_response(MenuItemSerializer.new(@menu_item).as_json)
    else
      json_response @menu_item.errors, :unprocessable_entity
    end
  end

  # DELETE users/1/menus/1/menu_items/1
  def destroy
    @menu_item.destroy
    json_response :ok
  end

  private

  def can?
    return if current_user != @user || !current_user.admin?
    json_response({ error: 'Forbidden' }, 403)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_menu
    @menu = @user.menus.find(params[:menu_id])
  end

  def set_menu_item
    @menu_item = @menu.menu_items.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def menu_item_params
    params.permit(:primary_label, :secondary_label, :recipe_id)
  end
end
