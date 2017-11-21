class MenusController < ApplicationController
  before_action :set_menu, only: [:show, :update, :destroy]

  # GET /menus
  def index
    @menus = Menu.all

    json_response @menus
  end

  # GET /menus/1
  def show
    json_response @menu
  end

  # POST /menus
  def create
    @menu = Menu.new(menu_params)

    if @menu.save
      json_response @menu, :created
    else
      json_response @menu.errors, :unprocessable_entity
    end
  end

  # PATCH/PUT /menus/1
  def update
    if @menu.update(menu_params)
      json_response @menu
    else
      json_response @menu.errors, :unprocessable_entity
    end
  end

  # DELETE /menus/1
  def destroy
    @menu.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu
      @menu = Menu.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def menu_params
      params.permit(:title, :user_id)
    end
end
