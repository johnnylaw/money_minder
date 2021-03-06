module ActsAsTransactionRecipeVirtualPortion
  module ActiveRecordBaseExt
    def acts_as_transaction_recipe_virtual_portion
      send(:include, ActsAsTransactionRecipeVirtualPortion)
    end
  end
  
  def self.included(base)
    base.class_eval do
      belongs_to  :virtual_account

      composed_of :amount,
        :class_name => "Money",
        :mapping => [%w(cents cents)],
        :constructor => Proc.new { |cents| Money.new(cents || 0) },
        :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }

      validates   :virtual_account_id, :presence => true
    end
  end
  
end

ActiveRecord::Base.send(:extend, ActsAsTransactionRecipeVirtualPortion::ActiveRecordBaseExt)