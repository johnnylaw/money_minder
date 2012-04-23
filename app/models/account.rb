require 'acts_as_account'

class Account < ActiveRecord::Base
  acts_as_account
  
  belongs_to  :holding_account, :class_name => 'Account'

  scope :spending_accounts, where(:is_spending => true)
  scope :holding_accounts,  where(:is_holding  => true)
  
end
