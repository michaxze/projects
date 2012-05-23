class GlobalSetting < ActiveRecord::Base

  class << self
    def bycode(code)
      s = GlobalSetting.find_by_code(code) rescue nil
    end
  end
end