module WelcomeHelper

  def set_package_css(package)
    unless package.nil?
      if ["basic_monthly", "basic_yearly"].include?(package.package_code)
        "basicP"
      elsif ["premium_monthly", "premium_yearly"].include?(package.package_code)
        "premiumP"
      else
        "freeP"
      end
    end 
  end
end
