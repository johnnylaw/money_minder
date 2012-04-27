require 'acts_as_transaction'

class VirtualRevenue < ActiveRecord::Base
  acts_as_transaction
  
  belongs_to  :revenue,     :class_name => 'VirtualRevenue'
  belongs_to  :account_to,  :class_name => 'VirtualAccount'
  
  scope     :to_account,    lambda{ |acct| where(:account_to_id => acct.id) }
end