class Announcement < ActiveRecord::Base
  belongs_to :announceable, :polymorphic => :true
  belongs_to :place
  scope :promotions, where("announce_type='promotion'")
  scope :announces, where("announce_type='announcement'")

  has_attached_file :banner,
                    :styles => { :large => "728x90>", :medium => "300x60>", :thumb => "50x50>" },
                    :url => "/system/uploads/:class/:attachment/:id/:basename_:style.:extension"
  validates_attachment_size :banner, :less_than => 1.megabytes
  validates_attachment_content_type :banner, :content_type => %w( image/jpeg image/png image/gif image/pjpeg image/x-png image/x-ms-bmp image/x-xbitmap image/x-xpixmap image/ief image/tiff image/bmp image/ief image/pipeg )



  class << self
    def get_announcements(page)
      paginate :page => page,
               :order => "created_at DESC"
    end

    def create_update(params, id=nil)
      a = Announcement.find(id) || Announcement.new
      a.title = params[:title] unless params[:title].blank?
      a.contents = params[:contents] unless params[:contents].blank?
      a.title = params[:title] unless params[:title].blank?
      a.title = params[:title] unless params[:title].blank?
      a.title = params[:title] unless params[:title].blank?
      a.title = params[:title] unless params[:title].blank?

    end
  end

  def short_title
    self.title[0, 50]
  end
  alias :name :short_title

  def short_description
    self.contents[0, 100]
  end
end
