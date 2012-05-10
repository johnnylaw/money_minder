class Customer < ActiveRecord::Base
  has_many :revenues
  
  def to_param
    name
  end
end
