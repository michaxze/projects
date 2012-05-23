class Payment < ActiveRecord::Base
  belongs_to :package
  
  class << self
    
    def create_invoice_number(package_code)
      #year-month&date-A01
      parts []
      parts << Time.now.year
      parts << "#{Time.now.month.to_s.rjust(2, '0')}#{Time.now.day.to_s.rjust(2, '0')}"
      parts << case package_code
      when 'basic_monthly'
        "B#{rand(99)}"
      when 'basic_yearly'
        "B#{rand(99)}"
      when 'premium_monthly'
        "P#{rand(99)}"
      when 'premium_basic'
        "P#{rand(99)}"        
      else
        'F'
      end
      parts.join("-")      
    end
      
    def free_account(user)
      unless user.nil?
        p = Payment.new
        p.user_id = user.id
        p.package_id = Package.find_by_package_code('free').id
        p.amount = 0
        p.contract_start = Time.now
        p.contract_end = Time.now + 12.months
        p.save!
      end
    end
  end

end
