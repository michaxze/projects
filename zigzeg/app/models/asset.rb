class Asset < ActiveRecord::Base
  belongs_to :uploadable, :polymorphic => true
  belongs_to :authorable, :polymorphic => true

  has_attached_file :image,
                    :styles => {:large => "650", :medium => "250", :thumb2 => "160x121#", :thumb => "182x152#", :thumb10070 => "100x70#", :super_thumb => "62x59#", :profile => "180x150#" },
                    :url => "/system/uploads/:class/:attachment/:id/:basename_:style.:extension",
                    :default_style => :large,
                    :default_url => '/images/missing.png'

  validates_attachment_size :image, :less_than => 4.megabyte
  validates_attachment_content_type :image, :content_type => %w( image/jpeg image/png image/gif image/pjpeg image/x-png image/x-ms-bmp image/x-xbitmap image/x-xpixmap image/ief image/tiff image/bmp image/ief image/pipeg )

  belongs_to :listing
  belongs_to :advertisements
  belongs_to :organizer
  belongs_to :user
  belongs_to :temp_image
end
