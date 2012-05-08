class VirtualTransfer < ActiveRecord::Base
  belongs_to  :account_from,  :class_name => 'VirtualAccount'
  belongs_to  :account_to,    :class_name => 'VirtualAccount'

# Everything below this line belongs in acts_as_transfer and included here and in Transfer class  
  composed_of :amount,
    :class_name => "Money",
    :mapping => [%w(cents cents)],
    :constructor => Proc.new { |cents| Money.new(cents || 0) },
    :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }
  
  scope     :from_account,  lambda{ |acct| where(:account_from_id => acct.id) }
  scope     :to_account,    lambda{ |acct| where(:account_to_id => acct.id) }

  validates :account_from,  :existing_record => true, :allow_nil => false
  validates :account_to,    :existing_record => true, :allow_nil => false
  validates :memo,          :presence => true
  validates :executed_at,   :presence => true
  validates :cents,         :presence => true, :numericality => { :integer_only => true }
  
end