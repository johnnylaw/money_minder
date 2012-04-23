class CreateTransactions < ActiveRecord::Migration
  COLUMNS_IN_TABLES = {
    :vendor_id        => [:purchases],
    :account_from_id  => [:purchases, :transfers],
    :account_to_id    => [            :transfers, :revenues],
    :customer_id      => [                        :revenues],
    :cents            => [            :transfers]
  }
  
  def table_has_column?(table, column)
    return true if table == :transaction_template
    return COLUMNS_IN_TABLES[column].include? table
  end
  
  def table_is_template?(table)
    table.to_s.include?('template')
  end
  
  def change
    [:purchases, :transfers, :revenues, :transaction_template].each do |table|
      create_table table do |t|
        t.integer(  :vendor_id,       :null => table_is_template?(table))   if table_has_column?(table, :vendor_id)
        t.integer(  :account_from_id, :null => table_is_template?(table))   if table_has_column?(table, :account_from_id)
        t.integer(  :account_to_id,   :null => table_is_template?(table))   if table_has_column?(table, :account_to_id)
        t.integer(  :customer_id,     :null => table_is_template?(table))   if table_has_column?(table, :customer_id)
        t.string(   :memo)
        t.integer(  :cents,          :null => table_is_template?(table))   if table_has_column?(table, :cents)
        t.datetime( :executed_at,     :null => table_is_template?(table))

        t.timestamps
      end
      
      add_index table, :executed_at
    end

    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      [:purchases, :transfers, :revenues].each do |table|
        execute %{ ALTER TABLE #{table} ADD FOREIGN KEY (vendor_id) REFERENCES vendors(id) } if table_has_column?(table, :vendor_id)
        execute %{ ALTER TABLE #{table} ADD FOREIGN KEY (account_from_id) REFERENCES accounts(id) } if table_has_column?(table, :account_from_id)
        execute %{ ALTER TABLE #{table} ADD FOREIGN KEY (account_to_id) REFERENCES accounts(id) } if table_has_column?(table, :account_to_id)
        execute %{ ALTER TABLE #{table} ADD FOREIGN KEY (customer_id) REFERENCES customers(id) } if table_has_column?(table, :customer_id)
      end
    end
  end
end
