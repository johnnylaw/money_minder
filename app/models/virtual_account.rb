require 'acts_as_account'

class VirtualAccount < ActiveRecord::Base
  belongs_to  :primary_spending_account, :class_name => 'Account'
  has_many    :purchases,     :foreign_key => :account_from_id, :class_name => 'VirtualPurchase'
  has_many    :revenues,      :foreign_key => :account_to_id,   :class_name => 'VirtualRevenue'
  has_many    :transfers_to,  :foreign_key => :account_to_id,   :class_name => 'VirtualTransfer'
  has_many    :transfers_from,:foreign_key => :account_from_id, :class_name => 'VirtualTransfer'
  
  default_scope order(:name)

  def balance
    Money.new(
      VirtualRevenue.to_account(self).sum(:cents) + VirtualTransfer.to_account(self).sum(:cents) -
      VirtualTransfer.from_account(self).sum(:cents) - VirtualPurchase.from_account(self).sum(:cents)
    )
  end
  
  def to_param
    name
  end
  
  def transactions
    [purchases, revenues, transfers_to, transfers_from].flatten.sort{ |x, y| y.executed_at <=> x.executed_at }
  end
  
  def running_balances
    size = transactions.size
    running_balances = Array.new(size)
    (transactions.reverse).each_with_index do |trans, i|
      puts '*******'
      puts "i: #{i}; Transaction amount: #{trans.amount}"
      last_balance = running_balances[size-i] || Money.new(0)
      puts "Last balance: #{last_balance}"
      if trans.respond_to?(:account_from)
        running_balances[size-i-1] = last_balance - trans.amount
      elsif trans.respond_to?(:account_to)
        running_balances[size-i-1] = last_balance + trans.amount
      end
    end
    running_balances
  end
  
end
  