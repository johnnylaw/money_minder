class Refund < Purchase
  class EmptinessValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors.add attribute, (options[:message] || "cannot exist") unless
        value.respond_to?(:empty?) && value.empty?
    end
  end
  
  # default_scope joins(:virtual_refunds)..where('cents < 0') This is not even close. Good luck
  
  has_many :virtual_refunds, :foreign_key => :purchase_id
  
  validates :virtual_purchases, :emptiness => true
  validates :virtual_refunds, :presence_of_associated => true  
end