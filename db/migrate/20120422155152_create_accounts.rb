class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name, :null => false, :unique => true
      t.boolean :is_spending, :default => false
      t.boolean :is_holding, :default => false
      t.integer :holding_account_id, :null => true

      t.timestamps
    end
    
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      execute %{ ALTER TABLE accounts ADD FOREIGN KEY (holding_account_id) REFERENCES accounts(id) }
    end
  end
end
