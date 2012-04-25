module ActsAsTransaction
  
  module ActiveRecordBaseExt
    def acts_as_transaction
      send(:include, ActsAsTransaction)
    end
  end
  
  def self.included(base)
    base.class_eval do
      composed_of :amount,
        :class_name => "Money",
        :mapping => [%w(cents cents)],
        :constructor => Proc.new { |cents| Money.new(cents || 0) },
        :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }

    end
  end

end

ActiveRecord::Base.send(:extend, ActsAsTransaction::ActiveRecordBaseExt)