class Transfer < ActiveRecord::Base
  belongs_to  :account_from,  :class_name => 'Account'
  belongs_to  :account_to,    :class_name => 'Account'
  
  scope     :from_account,  lambda{ |acct| where(:account_from_id => acct.id) }
  scope     :to_account,    lambda{ |acct| where(:account_to_id => acct.id) }
end