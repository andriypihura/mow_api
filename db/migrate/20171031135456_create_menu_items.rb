class CreateMenuItems < ActiveRecord::Migration[5.1]
  def change
    create_table :menu_items do |t|
      t.string :primary_label
      t.string :secondary_label
      t.references :recipe, foreign_key: true
      t.references :menu, foreign_key: true

      t.timestamps
    end
  end
end
