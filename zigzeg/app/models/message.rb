class Message < ActiveRecord::Base
  scope :unread, lambda { |user|
    where("is_viewed=0 AND viewer_id=? AND viewer_type=?", user.id, user.class.name)
  }

  belongs_to :sender,   :polymorphic => true
  belongs_to :receiver, :polymorphic => true
  belongs_to :viewer,   :polymorphic => true
  belongs_to :email_template
  belongs_to :message_thread

  self.per_page = 10

  #msgtype - contactus, inbox, sent, notification, promotion

  class << self
    def sent_announcements(page)
      paginate :page => page,
               :conditions => "msgtype='announcement'",
               :order => "created_at DESC"
    end

    def sent_contactus(page)
      paginate :page => page,
               :conditions => "msgtype='contactus_sent'",
               :order => "created_at DESC"
    end

    def sent(user, usertype, page)
      users = User.where("user_type='#{usertype}'")
      user_ids = users.map(&:id).uniq

      paginate :page => page,
               :group => "message_thread_id",
               :conditions => ["sender_id = ? AND msgtype='sent' AND receiver_id IN (?)", user.id, user_ids],
               :order => "created_at DESC"

    end

    def has_permission?(user, msg)
      return true if user.is_admin?
      return true if user == msg.viewer
      false
    end

    def announcements(user, page)
      paginate :page => page,
               :conditions => "msgtype='notification'",
               :order => "created_at DESC"
    end

    def contactus(user, page)
      paginate :page => page,
               :conditions => "msgtype='contactus'",
               :order => "created_at DESC"
    end

    def from_members(user, page)
      users = User.where("user_type='member'").includes(:messages).where("messages.receiver_id=#{user.id} AND messages.msgtype='inbox'")
      message_ids = []
      users.each {|u| message_ids += u.messages.map(&:id) }
      message_ids.uniq!

      paginate :page => page,
               :conditions => ["id IN (?)", message_ids],
               :order => "created_at DESC"
    end

    def from_advertisers(user, page)
      users = User.where("user_type='advertiser'").includes(:messages).where("messages.receiver_id=#{user.id} AND messages.msgtype='inbox'")
      message_ids = []
      users.each {|u| message_ids += u.messages.map(&:id) }
      message_ids.uniq!

      paginate :page => page,
               :conditions => ["id IN (?)", message_ids],
               :order => "created_at DESC"
    end
  end

  def inbox_threads
    Message.where("message_thread_id=? AND viewer_id=? AND msgtype='inbox'", self.message_thread_id, self.viewer_id).order("created_at DESC")
  end

  def threads
    Message.where("message_thread_id=? AND viewer_id=? ", self.message_thread_id, self.viewer_id).order("created_at DESC")
  end

  def html_contents
    self.contents.gsub("\n", "<br/>")
  end

  def delete_mthreads
    thread_id = self.message_thread_id
    Message.where("message_thread_id = ? AND viewer_id = ? AND viewer_type='User'", thread_id, self.viewer_id).delete_all
    MessageThread.find(thread_id).destroy rescue nil
  end

  def get_sendto(viewer)
    if self.msgtype == 'sent'
        self.receiver
    else
      self.sender
    end
  end
end
