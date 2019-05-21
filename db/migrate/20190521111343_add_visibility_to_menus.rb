class AddVisibilityToMenus < ActiveRecord::Migration[5.1]
  def change
    add_column :menus, :visibility, :string, :default => 'for self'
  end
end
