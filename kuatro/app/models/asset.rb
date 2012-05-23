class Asset < ActiveRecord::Base
  belongs_to :uploadable, :polymorphic => true
  belongs_to :authorable, :polymorphic => true

  has_attached_file :file,
                    :styles => {:large => "800", :medium => "500x340" },
                    :default_style => :large

  validates_attachment_size :file, :less_than => 4.megabyte
  validates_attachment_content_type :file, :content_type => %w( image/jpeg image/png image/gif image/pjpeg image/x-png image/x-ms-bmp image/x-xbitmap image/x-xpixmap image/ief image/tiff image/bmp image/ief image/pipeg )

end