class Revenue < ActiveRecord::Base
  belongs_to  :account_from, :class_name => 'Account'
  belongs_to  :customer
  has_many    :virtual_revenues
  
  scope     :to_account,    lambda{ |acct| where(:account_to_id => acct.id) }
  
end