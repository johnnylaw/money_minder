class CreateVirtualTransactions < ActiveRecord::Migration
  COLUMNS_IN_TABLES = {
    :purchase_id      => [:virtual_purchases],
    :revenue_id       => [                                        :virtual_revenues],
    :account_from_id  => [:virtual_purchases, :virtual_transfers],
    :account_to_id    => [                    :virtual_transfers, :virtual_revenues],
    :executed_at      => [                    :virtual_transfers]
  }
  
  def table_has_column?(table, column)
    return true if table == :virtual_transaction_template
    return COLUMNS_IN_TABLES[column].include? table
  end
  
  def table_is_template?(table)
    table.to_s.include?('template')
  end
  
  def change
    [:virtual_purchases, :virtual_transfers, :virtual_revenues, :virtual_transaction_template].each do |table|
      create_table table do |t|
        t.integer(  :purchase_id,     :null => table_is_template?(table))   if table_has_column?(table, :purchase_id)
        t.integer(  :revenue_id,      :null => table_is_template?(table))   if table_has_column?(table, :revenue_id)
        t.integer(  :account_from_id, :null => table_is_template?(table))   if table_has_column?(table, :account_from_id)
        t.integer(  :account_to_id,   :null => table_is_template?(table))   if table_has_column?(table, :account_to_id)
        t.integer   :cents,           :null => false
        t.datetime( :executed_at,     :null => table_is_template?(table))   if table_has_column?(table, :executed_at)

        t.timestamps
      end
      
      add_index(table, :executed_at) if table_has_column?(table, :executed_at)
    end

    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      [:purchases, :transfers, :revenues].each do |table|
        execute %{ ALTER TABLE #{table} ADD FOREIGN KEY (purchase_id) REFERENCES purchases(id) } if table_has_column?(table, :purchase_id)
        execute %{ ALTER TABLE #{table} ADD FOREIGN KEY (revenue_id) REFERENCES revenues(id) } if table_has_column?(table, :revenue_id)
        execute %{ ALTER TABLE #{table} ADD FOREIGN KEY (account_from_id) REFERENCES virtual_accounts(id) } if table_has_column?(table, :account_from_id)
        execute %{ ALTER TABLE #{table} ADD FOREIGN KEY (account_to_id) REFERENCES virtual_accounts(id) } if table_has_column?(table, :account_to_id)
      end
    end
  end
end
