class TempImage < ActiveRecord::Base
  set_table_name "temp_photos"
  has_many :assets, :as => :uploadable, :dependent => :destroy

  class << self
    def get_profile_image_url(user, section ='section_type')
      img = TempImage.find(:last, :conditions => ["user_id = ? AND section_type = ?", user.id, section])
      unless img.nil?
        return img.assets.first.image.url(:thumb).to_s rescue ''
      end
    end

    def get_profile(user)
      TempImage.find(:last, :conditions => ["user_id = ? AND section_type='profile'", user.id])
    end

    def get_gallery(user)
      TempImage.find(:all, :conditions => ["user_id = ? AND section_type='gallery'", user.id])
    end
  end
end
