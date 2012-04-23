require 'acts_as_account'

class VirtualAccount < ActiveRecord::Base
  belongs_to  :primary_spending_account, :class_name => 'Account'
  
end
  