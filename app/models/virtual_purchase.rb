require 'acts_as_transaction'

class VirtualPurchase < ActiveRecord::Base
  acts_as_transaction

  belongs_to    :purchase
  belongs_to    :account_from, :class_name => 'VirtualAccount'

  scope     :from_account, lambda{ |acct| where(:account_from_id => acct.id) }
  
end