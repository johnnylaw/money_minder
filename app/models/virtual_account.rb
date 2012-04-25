require 'acts_as_account'

class VirtualAccount < ActiveRecord::Base
  belongs_to  :primary_spending_account, :class_name => 'Account'
  has_many    :purchases,     :foreign_key => :account_from_id, :class_name => 'VirtualPurchase'
  has_many    :revenues,      :foreign_key => :account_to_id,   :class_name => 'VirtualRevenue'
  has_many    :transfers_to,  :foreign_key => :account_to_id,   :class_name => 'VirtualTransfer'
  has_many    :transfers_from,:foreign_key => :account_from_id, :class_name => 'VirtualTransfer'

  def balance
    Money.new(
      VirtualRevenue.to_account(self).sum(:cents) + VirtualTransfer.to_account(self).sum(:cents) -
      VirtualTransfer.from_account(self).sum(:cents) - VirtualPurchase.from_account(self).sum(:cents)
    )
  end
  
  def to_param
    name
  end
end
  