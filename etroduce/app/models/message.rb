class Message < ActiveRecord::Base
  belongs_to :opportunity
  belongs_to :user
  
  belongs_to :message_thread
  
  class << self
    def count_newmessages(user)
      Message.count(:conditions => ["to_id = ? AND msgtype='inbox' AND read_at IS NULL", user.id])
    end

    def create_thread(from, to, params)
      thread = MessageThread.new
      thread.to_id = to.id
      thread.from_id = from.id
      thread.opportunity_id = params[:opportunity_id] unless params[:opportunity_id].nil?
      thread.save!
      thread
    end

    def send_respond(from, to, params)

      thread = MessageThread.new
      thread.subject = params[:subject]
      thread.to_id = to.id
      thread.from_id = from.id
      thread.opportunity_id = params[:opp_id] unless params[:opp_id].nil?
      thread.referred_email = params[:referred_email].first unless params[:referred_email].nil?
      thread.save

      msg = Message.new
      msg.body = params[:body]
      msg.msgtype = params[:type]
      msg.from_id = from.id
      msg.to_id = to.id
      msg.message_thread_id = thread.id
      msg.viewable_to = to.id
      msg.msgtype = params[:msgtype].nil? ? "inbox" : params[:msgtype]
      msg.save
      msg
    end
    
    def create_message(msg)
      msg = Message.create!(msg)
    end
    
    def get_messages(user, msg_label='inbox', page=nil, unread_only=false)
      if msg_label == 'inbox'
        paginate :page => page,
                 :per_page => 15,
                 :conditions => ["msgtype=? AND to_id = ?", msg_label, user.id],
                 :order => "created_at DESC"        
      elsif msg_label == "sent"
        paginate :page => page,
                 :per_page => 15,
                 :conditions => ["msgtype=? AND from_id = ?", msg_label, user.id],
                 :order => "created_at DESC"
      elsif msg_label == "refer"
        paginate :page => page,
                 :per_page => 15,
                 :conditions => ["msgtype=? AND to_id = ?", msg_label, user.id],
                 :order => "created_at DESC"
      end
    end
    
    def get_referred(user)
      messages = Message.find(:all, :conditions => ["referred_email = ? AND parent_id IS NULL", user.email], :order => "created_at DESC")
    end
    
    def get_sent(user)
      messages = Message.find(:all, :conditions => ["msgtype='inbox' AND from_id = ?", user.id], :order => "created_at DESC")
    end
    
  end
  
  def receiver
    User.find(self.to_id) rescue nil
  end

  def threads_and_parent
    ids = [self.id, self.parent_id]
    ids.compact!
    msgs = Message.find(:all, :conditions => ["id IN (?) || parent_id IN (?) ", ids, ids], :order => "created_at ASC")
  end
  
  def threads
    msgs = Message.find(:all, :conditions => ["parent_id = ?", self.parent_id], :order => "created_at ASC")
  end
  
  def sender
    User.find(self.from_id) rescue nil
  end
  
  def parent_message
    Message.find(self.parent_id) rescue nil
  end

  def get_threads
    Message.find(:all, :conditions => ["message_thread_id = ? AND viewable_to = ?", self.message_thread_id, self.viewable_to])
  end
  
end
