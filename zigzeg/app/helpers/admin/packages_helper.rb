module Admin::PackagesHelper
  
  def show_discount_status(discount)
    status = "pending"

    unless discount.nil?
      unless discount.start_date.nil?
        if discount.start_date >= Time.now.to_date
          status = "live"
        end
      end
      
      unless discount.end_date.nil?
        if Time.now.to_date > discount.end_date
          status = "expired"
        end
      end
    end
    
    status
  end
  
end