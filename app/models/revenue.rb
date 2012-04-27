class Revenue < ActiveRecord::Base
  belongs_to  :account_from, :class_name => 'Account'
  belongs_to  :customer
  has_many    :virtual_revenues
  belongs_to  :expected_revenue
  
  accepts_nested_attributes_for :virtual_revenues
  before_save :process_expected_revenue, :if => proc { |p| p.expected_revenue_id }
  attr_accessor :total_amount
  
  scope     :to_account,    lambda{ |acct| where(:account_to_id => acct.id) }
  
  def self.new_from_expected_revenue(exp_rev)
    revenue = new(:expected_revenue => exp_rev)
    revenue.memo = exp_rev.recipe.name
    revenue.total_amount = exp_rev.recipe.amount
    revenue.customer = exp_rev.recipe.customer
    revenue.build_virtual_revenues
    revenue
  end
  
  def build_virtual_revenues
    expected_revenue.recipe.virtual_portions.each do |virtual_portion|
      self.virtual_revenues.build(:account_to => virtual_portion.virtual_account, :cents => virtual_portion.cents)
    end
  end
  
  def spill_over_virtual_revenue
    remaining_cents = expected_revenue.recipe.cents - expected_revenue.recipe.virtual_portions.sum(:cents)
    VirtualRevenue.new(:account_to => expected_revenue.recipe.spill_over_virtual_account, :cents => remaining_cents)
  end
    
end