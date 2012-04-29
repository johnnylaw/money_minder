require 'acts_as_expected_transaction'

class ExpectedRevenue < ActiveRecord::Base
  acts_as_expected_transaction
  belongs_to  :recipe, :class_name => 'RevenueRecipe', :foreign_key => :transaction_recipe_id
  
  scope :outstanding, joins('LEFT OUTER JOIN revenues p ON p.expected_revenue_id=expected_revenues.id').
                      where('p.expected_revenue_id is null').
                      where(:is_complete => false)  
  
  def unused_virtual_accounts
    VirtualAccount.all - recipe.virtual_accounts - [recipe.spill_over_virtual_account]
  end
  
end