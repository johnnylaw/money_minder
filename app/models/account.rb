require 'acts_as_account'

class Account < ActiveRecord::Base
  acts_as_account
  
  belongs_to  :holding_account, :class_name => 'Account'

  scope :spending_accounts, where(:is_spending => true)
  scope :holding_accounts,  where(:is_holding  => true)

  #  TODO: Revenue and Purchase amounts are the SUMs of their virtual_revenues and virtual_purchases
  #        Will require a join in each case and probably .sum('"virtual_revenues"."cents"') etc.
  def balance
    Money.new(
      Revenue.to_account(self).joins(:virtual_revenues).sum('"virtual_revenues"."cents"').to_i +
      Transfer.to_account(self).sum(:cents) - Transfer.from_account(self).sum(:cents) - 
      Purchase.from_account(self).joins(:virtual_purchases).sum('"virtual_purchases"."cents"').to_i
    )
  end
  
end