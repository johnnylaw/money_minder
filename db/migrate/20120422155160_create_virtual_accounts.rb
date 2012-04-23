class CreateVirtualAccounts < ActiveRecord::Migration
  def change
    create_table :virtual_accounts do |t|
      t.string  :name, :null => false
      t.integer :primary_spending_account_id, :null => true
      
      t.timestamps
    end
    
    add_index :virtual_accounts, :name, :unique => true
    
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      execute %{ ALTER TABLE virtual_accounts ADD FOREIGN KEY (primary_spending_account_id) REFERENCES accounts(id) }
    end
    
  end
end
