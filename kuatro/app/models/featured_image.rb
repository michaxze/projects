class FeaturedImage < ActiveRecord::Base  

  has_attached_file :fimage, :styles => {:large => "900x611", :thumb => "150x110#", :small => "72x67#", :medium => "616x370#" }
  validates_attachment_size :fimage, :less_than => 4.megabyte
  validates_attachment_content_type :fimage, :content_type => %w( image/jpeg image/png image/gif image/pjpeg image/x-png image/x-ms-bmp image/x-xbitmap image/x-xpixmap image/ief image/tiff image/bmp image/ief image/pipeg )
  
#  validates_attachment_presence :image
#  attr_accessor :image
end
