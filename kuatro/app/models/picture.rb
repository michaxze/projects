class Picture < ActiveRecord::Base  
  belongs_to :album

  has_attached_file :image, :styles => {:large => "800", :thumb => "180x120#" }
  validates_attachment_size :image, :less_than => 6.megabyte
  validates_attachment_content_type :image, :content_type => %w( image/jpeg image/png image/gif image/pjpeg image/x-png image/x-ms-bmp image/x-xbitmap image/x-xpixmap image/ief image/tiff image/bmp image/ief image/pipeg )

end
