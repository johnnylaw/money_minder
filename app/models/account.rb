require 'acts_as_account'

class Account < ActiveRecord::Base
  acts_as_account
  
  belongs_to  :holding_account, :class_name => 'Account'
  
  has_many    :purchases,     :foreign_key => :account_from_id, :class_name => 'Purchase'
  has_many    :revenues,      :foreign_key => :account_to_id,   :class_name => 'Revenue'
  has_many    :transfers_to,  :foreign_key => :account_to_id,   :class_name => 'Transfer'
  has_many    :transfers_from,:foreign_key => :account_from_id, :class_name => 'Transfer'
  
  scope :spending_accounts, where(:is_spending => true)
  scope :holding_accounts,  where(:is_holding  => true)

  #  TODO: Revenue and Purchase amounts are the SUMs of their virtual_revenues and virtual_purchases
  #        Will require a join in each case and probably .sum('"virtual_revenues"."cents"') etc.
  def balance
    Money.new(
      Revenue.to_account(self).joins(:virtual_revenues).sum('"virtual_revenues"."cents"').to_i +
      Transfer.to_account(self).sum(:cents) - Transfer.from_account(self).sum(:cents) - 
      Purchase.from_account(self).joins(:virtual_purchases).sum('"virtual_purchases"."cents"').to_i +
      self.initial_balance_in_cents
    )
  end
  
  def transactions
    [purchases, revenues, transfers_to, transfers_from].flatten.sort{ |x, y| y.executed_at <=> x.executed_at }
  end

  def running_balances
    size = transactions.size
    running_balances = Array.new(size + 1)
    (transactions.reverse).each_with_index do |trans, i|
      last_balance = running_balances[size-i] || self.initial_balance
      if trans.respond_to?(:account_from) && trans.account_from == self
        running_balances[size-i-1] = last_balance - trans.amount
      elsif trans.respond_to?(:account_to) && trans.account_to == self
        running_balances[size-i-1] = last_balance + trans.amount
      end
    end
    running_balances
  end
  
end