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

# Possible refactor
# :purchase
  # has_many :virtual_transactions, :foreign_key => :purchase_id, :class_name => 'VirtualPurchase'
  
# :transfer
# :revenue
  # has_many :virtual_transactions, :foreign_key => :revenue_id, :class_name => 'VirtualRevenue'
  
# :virtual_purchase
  # belongs_to :transaction, :class_name => 'Purchase', :foreign_key => :purchase_id
  
# :virtual_transfer

# :virtual_revenue
  # belongs_to :transaction, :class_name => 'Revenue', :foreign_key => :revenue_id
  
# class_name = self.class.to_s
# class_name_instance = class_name.underscore
# if class_name.match? /^Virtual/
  # assoc_transaction_class_name = class_name.sub(/^Virtual/, '')
  # belongs_to :transaction, :class_name = assoc_transaction_class_name, :foreign_key => 