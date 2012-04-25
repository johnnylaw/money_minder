class AddExpectedTransactionIdToTransactions < ActiveRecord::Migration
  def change
    add_column :purchases,            :expected_purchase_id, :integer, :null => true
    add_column :transaction_template, :expected_purchase_id, :integer, :null => true

    add_column :revenues,             :expected_revenue_id, :integer, :null => true
    add_column :transaction_template, :expected_revenue_id, :integer, :null => true
    
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      execute %{ ALTER TABLE purchases ADD FOREIGN KEY (expected_purchase_id) REFERENCES expected_purchases(id) }
      execute %{ ALTER TABLE revenues ADD FOREIGN KEY (expected_revenue_id) REFERENCES expected_revenues(id) }
    end
  end
end
