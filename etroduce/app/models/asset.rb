class Asset < ActiveRecord::Base

  has_attached_file :image, :styles => {:large => "750x650>", :medium => "250x250>", :thumb2 => "200x200", :thumb => "100x100", :super_thumb => "50x50" }
  validates_attachment_size :image, :less_than => 10.megabytes
  validates_attachment_content_type :image, :content_type => %w( image/jpeg image/png image/gif image/pjpeg image/x-png image/x-ms-bmp image/x-xbitmap image/x-xpixmap image/ief image/tiff image/bmp image/ief image/pipeg )

  belongs_to :opportunity
end
