module ActsAsExpectedTransaction
  
  module ActiveRecordBaseExt
    def acts_as_expected_transaction
      send(:include, ActsAsExpectedTransaction)
    end
  end
  
  def self.included(base)
    base.class_eval do
      default_scope order('scheduled_on desc, scheduled_for_hour asc')
      
      def self.find_or_create_by_recipe_and_date(recipe, date)
        where(:transaction_recipe_id => recipe.id).where(:scheduled_on => date).first ||
          create(:transaction_recipe_id => recipe.id, :scheduled_on => date, :scheduled_for_hour => recipe.hour)
      end
      
      def complete
        update_attribute(:is_complete, true)
      end
    end
  end

end

ActiveRecord::Base.send(:extend, ActsAsExpectedTransaction::ActiveRecordBaseExt)