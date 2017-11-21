class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: [:show, :update, :destroy]

  # GET /menu_items
  def index
    @menu_items = MenuItem.all

    json_response @menu_items
  end

  # GET /menu_items/1
  def show
    json_response @menu_item
  end

  # POST /menu_items
  def create
    @menu_item = MenuItem.new(menu_item_params)

    if @menu_item.save
      json_response @menu_item, :created
    else
      json_response @menu_item.errors, :unprocessable_entity
    end
  end

  # PATCH/PUT /menu_items/1
  def update
    if @menu_item.update(menu_item_params)
      json_response @menu_item
    else
      json_response @menu_item.errors, :unprocessable_entity
    end
  end

  # DELETE /menu_items/1
  def destroy
    @menu_item.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu_item
      @menu_item = MenuItem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def menu_item_params
      params.permit(:primary_label, :secondary_label, :menu_id, :recipe_id)
    end
end
