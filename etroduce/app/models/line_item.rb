class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :opportunity
  
  def full_price
    unit_price * quantity
  end
end
