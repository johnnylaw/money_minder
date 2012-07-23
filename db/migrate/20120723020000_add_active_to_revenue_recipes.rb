class AddActiveToRevenueRecipes < ActiveRecord::Migration
  def change
    add_column :revenue_recipes, :active, :boolean, default: true
  end
end
