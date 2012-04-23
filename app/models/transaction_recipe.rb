class TransactionRecipe < ActiveRecord::Base
  set_table_name :transaction_recipe_template
  
  belongs_to    :spill_over_virtual_account, :class_name => 'VirtualAccount'
  belongs_to    :default_inside_account, :class_name => 'Account'
end