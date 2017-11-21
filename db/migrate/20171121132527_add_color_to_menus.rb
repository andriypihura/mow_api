class AddColorToMenus < ActiveRecord::Migration[5.1]
  def change
    add_column :menus, :color, :string
  end
end
