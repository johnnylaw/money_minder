class CreateExpectedTransactions < ActiveRecord::Migration
  def change
    [:expected_purchases, :expected_revenues, :expected_transaction_template].each do |table|
      create_table table do |t|
        t.integer   :transaction_recipe_id, :null => (table != :expected_transaction_template)
        t.date      :scheduled_on
        t.integer   :scheduled_for_hour
        t.boolean   :is_complete, :default => false
      
        t.timestamps
      end
    end
    
    add_index     :expected_revenues, :scheduled_on
    add_index     :expected_purchases, :scheduled_on

    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      execute %{ ALTER TABLE expected_purchases ADD FOREIGN KEY (transaction_recipe_id) REFERENCES purchase_recipes(id) }
      execute %{ ALTER TABLE expected_revenues ADD FOREIGN KEY (transaction_recipe_id) REFERENCES revenue_recipes(id) }
    end
  end
end
