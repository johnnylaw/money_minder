class CreateRecipeVirtualAccountPortions < ActiveRecord::Migration
  def change
    [:purchase_recipe_virtual_portions, :revenue_recipe_virtual_portions, :recipe_virtual_portion_template].each do |table|
      create_table table do |t|
        t.integer( :purchase_recipe_id, :null => false) if table == :purchase_recipe_virtual_portions
        t.integer( :purchase_recipe_id, :null => true ) if table == :recipe_virtual_portion_template
        
        t.integer( :revenue_recipe_id, :null => false)  if table == :revenue_recipe_virtual_portions
        t.integer( :revenue_recipe_id, :null => true)   if table == :recipe_virtual_portion_template
        
        t.integer :virtual_account_id, :null => false
        t.integer :cents, :null => false

        t.timestamps
      end
    end

    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      execute %{ ALTER TABLE purchase_recipe_virtual_portions ADD FOREIGN KEY (purchase_recipe_id) REFERENCES purchase_recipes(id) }
      execute %{ ALTER TABLE revenue_recipe_virtual_portions ADD FOREIGN KEY (revenue_recipe_id) REFERENCES revenue_recipes(id) }

      execute %{ ALTER TABLE purchase_recipe_virtual_portions ADD FOREIGN KEY (virtual_account_id) REFERENCES virtual_accounts(id) }
      execute %{ ALTER TABLE revenue_recipe_virtual_portions ADD FOREIGN KEY (virtual_account_id) REFERENCES virtual_accounts(id) }
    end

  end
  
end
