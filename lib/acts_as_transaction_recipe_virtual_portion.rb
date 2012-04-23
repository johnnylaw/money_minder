module ActsAsTransactionRecipeVirtualPortion
  module ActiveRecordBaseExt
    def acts_as_transaction_recipe_virtual_portion
      send(:include, ActsAsTransactionRecipeVirtualPortion)
    end
  end
  
  def self.included(base)
    base.class_eval do
      belongs_to  :virtual_account

      validates   :virtual_account_id, :presence => true
    end
  end
  
end

ActiveRecord::Base.send(:extend, ActsAsTransactionRecipeVirtualPortion::ActiveRecordBaseExt)