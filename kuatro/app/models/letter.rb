class Letter < ActiveRecord::Base

  has_attached_file :limage, :styles => {:large => "900x611", :thumb => "150x110#", :medium => "380x330" }
  validates_attachment_size :limage, :less_than => 4.megabyte
  validates_attachment_content_type :limage, :content_type => %w( image/jpeg image/png image/gif image/pjpeg image/x-png image/x-ms-bmp image/x-xbitmap image/x-xpixmap image/ief image/tiff image/bmp image/ief image/pipeg )

  validates_presence_of :author, :contents, :limage
  
end
