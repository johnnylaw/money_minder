require 'acts_as_transaction'

class VirtualRevenue < ActiveRecord::Base
  acts_as_transaction
  
  belongs_to  :revenue
  belongs_to  :account_to,  :class_name => 'VirtualAccount'
  
  scope     :to_account,    lambda{ |acct| where(:account_to_id => acct.id) }
  
  def inside_account
    account_to
  end
  
  def executed_at
    revenue.executed_at
  end
  
  def memo
    revenue.memo
  end
end