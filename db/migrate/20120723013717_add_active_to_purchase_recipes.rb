class AddActiveToPurchaseRecipes < ActiveRecord::Migration
  def change
    add_column :purchase_recipes, :active, :boolean, default: true
  end
end
