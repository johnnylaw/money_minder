class AddInitialBalanceInCentsToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :initial_balance_in_cents, :integer, :null => false, :default => 0
  end
end
