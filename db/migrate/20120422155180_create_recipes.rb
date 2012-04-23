class CreateRecipes < ActiveRecord::Migration
  def change
    [:purchase_recipes, :revenue_recipes, :transaction_recipe_template].each do |table|
      create_table table do |t|
        t.string  :name, :null => false
        t.integer :spill_over_virtual_account_id, :null => true

        t.integer( :vendor_id, :null => true)  if [:purchase_recipes, :transaction_recipe_template].include? table
        t.integer :default_inside_account_id, :null => false   # personal_account_id of spending or holding account
        t.integer( :customer_id, :null => table.to_s.include?('template'))  if [:revenue_recipes, :transaction_recipe_template].include? table

        t.string    :occurs_at
        t.string    :base_interval
        t.integer   :num_of_intervals, :default => false, :default => 1
        t.date      :starts_on
        t.date      :ends_on
        t.boolean   :is_promised
        t.integer   :current_as_of_hours_prior
        t.datetime  :max_scheduled_out_to, :null => false, :default => '1970-01-01 00:00:00'
        t.integer   :cents, :null => false

        t.timestamps
      end
    end
  
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      execute %{ ALTER TABLE purchase_recipes ADD FOREIGN KEY (spill_over_virtual_account_id) REFERENCES virtual_accounts(id) }
      execute %{ ALTER TABLE revenue_recipes ADD FOREIGN KEY (spill_over_virtual_account_id) REFERENCES virtual_accounts(id) }
      
      execute %{ ALTER TABLE purchase_recipes ADD FOREIGN KEY (default_inside_account_id) REFERENCES accounts(id) }
      execute %{ ALTER TABLE revenue_recipes ADD FOREIGN KEY (default_inside_account_id) REFERENCES accounts(id) }

      execute %{ ALTER TABLE purchase_recipes ADD FOREIGN KEY (vendor_id) REFERENCES vendors(id) }

      execute %{ ALTER TABLE revenue_recipes ADD FOREIGN KEY (customer_id) REFERENCES customers(id) }
    end

  end
  
end
