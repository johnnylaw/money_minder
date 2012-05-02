class AddInitialBalanceInCentsToVirtualAccounts < ActiveRecord::Migration
  def change
    add_column :virtual_accounts, :initial_balance_in_cents, :integer, :null => false, :default => 0
  end
end
