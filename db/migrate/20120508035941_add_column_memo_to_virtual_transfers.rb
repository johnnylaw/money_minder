class AddColumnMemoToVirtualTransfers < ActiveRecord::Migration
  def change
    add_column :virtual_transfers, :memo, :string, :null => false
    add_column :virtual_transaction_template, :memo, :string
  end
end
