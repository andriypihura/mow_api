class AddCaloriesToMenus < ActiveRecord::Migration[5.1]
  def change
    add_column :menus, :calories, :integer
  end
end
