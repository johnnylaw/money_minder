class Transfer < ActiveRecord::Base
  belongs_to  :account_from,  :class_name => 'Account'
  belongs_to  :account_to,    :class_name => 'Account'
  
  scope     :from_account,  lambda{ |acct| where(:account_from_id => acct.id) }
  scope     :to_account,    lambda{ |acct| where(:account_to_id => acct.id) }
  
  composed_of :amount,
    :class_name => "Money",
    :mapping => [%w(cents cents)],
    :constructor => Proc.new { |cents| Money.new(cents || 0) },
    :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }
  
end