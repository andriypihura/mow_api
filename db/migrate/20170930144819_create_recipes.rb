class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.belongs_to :user, index: true
      t.string :title

      t.timestamps
    end
  end
end
