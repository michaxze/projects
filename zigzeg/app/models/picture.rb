require 'mime/types'

class Picture < ActiveRecord::Base
  belongs_to :pictureable, :polymorphic => true

  belongs_to :user

  has_attached_file :image, :styles => {:large => "650", :offer => "633x500#", :medium => "250", :thumb_index => "160x121#", :thumb2 => "200x200#", :thumb1 => "152x102#", :thumb => "150x110#", :edthumb => "153x100#", :super_thumb => "62x59#", :gallery => "150x100#" }
  validates_attachment_size :image, :less_than => 4.megabyte
  validates_attachment_content_type :image, :content_type => %w( image/jpeg image/png image/gif image/pjpeg image/x-png image/x-ms-bmp image/x-xbitmap image/x-xpixmap image/ief image/tiff image/bmp image/ief image/pipeg )
  belongs_to :place

  after_update :update_listing

  def swfupload_file=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).to_s
    self.image = data
  end

  def update_listing
    unless self.pictureable.listing.nil?
      names = self.pictureable.pictures.map(&:name)
      names.compact!
      self.pictureable.listing.update_attribute(:gallery_title, names)

      descs = self.pictureable.pictures.map(&:description)
      descs.compact!
      self.pictureable.listing.update_attribute(:gallery_description, descs)
    end
  end
end
