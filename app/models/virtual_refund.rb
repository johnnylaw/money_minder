class VirtualRefund < VirtualPurchase
  belongs_to :refund, :foreign_key => :purchase_id
  validates :cents, :numericality => { :less_than => 0 }  
end