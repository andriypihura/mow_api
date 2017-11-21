class AddAdditionalFieldsToRecipes < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :image, :string
    add_column :recipes, :text, :string
    add_column :recipes, :ingredients, :string
    add_column :recipes, :categories, :string
    add_column :recipes, :complexity, :string
    add_column :recipes, :visibility, :string, :default => true
    add_column :recipes, :time_consuming, :integer
    add_column :recipes, :calories, :integer
  end
end
