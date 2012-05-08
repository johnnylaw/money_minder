class Vendor < ActiveRecord::Base
  validates :name, :uniqueness => true
  
  has_many  :purchases
  
  default_scope order(:name)
  
  def to_param
    name
  end
end
