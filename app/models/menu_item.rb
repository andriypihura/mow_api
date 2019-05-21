class MenuItem < ApplicationRecord
  belongs_to :recipe
  belongs_to :menu

  after_create :update_menu_calories
  after_destroy :update_menu_calories

  def update_menu_calories
    menu.update_calories
  end
end
