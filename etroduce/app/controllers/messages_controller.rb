class  MessagesController < ApplicationController
  layout 'login_manage'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authenticate  

  def markasunread
    if request.post?
      unless params[:message_id].nil?
        message_ids = params[:message_id]
        case params[:message_action].to_s
        when "mark_as_unread"
          message_ids.each do |m|
            m = Message.find(m.first.to_i)
            m.update_attribute(:read_at, nil)
          end
          flash[:notice] = "Messages marked as unread."
        when "delete"
          message_ids.each do |m|
            m = Message.find(m.first.to_i)
            m.destroy
          end
          flash[:notice] = "Messages deleted."
        end
      end
    end
    redirect_to request.referer
  end
  
  def show_send_message
    user = User.find(params[:id]) rescue nil
    render :text => render_to_string(:partial => "send_message", :locals => { :user => user})
  end
  
  def send_message
    if request.post?
      if params[:user_email].nil? || params[:user_email].empty?
        render :text => "Please select the correct name from the list."
      elsif params[:msg][:subject].blank?
        render :text => "Please enter the subject of your message"
      elsif params[:msg][:message].blank?
        render :text => "Please fill in message field"
      else
        to = User.find_by_email(params[:user_email].first)

        unless params[:thread_id].nil?
          thread = MessageThread.find(params[:thread_id])
        end
        
        if params[:msg][:thread_id].nil?
          thread         = MessageThread.new
          thread.subject = params[:msg][:subject]
          thread.to_id   = to.id
          thread.from_id = current_user.id
          thread.opportunity_id = params[:msg][:opportunity_id] unless params[:msg][:opportunity_id].nil?
          thread.save!
        end
        
        msg = {}
        msg[:body]    = params[:msg][:message]
        msg[:msgtype] = "sent"
        msg[:to_id]   = to.id
        msg[:from_id] = current_user.id
        msg[:message_thread_id] = thread.id rescue nil
        msg[:viewable_to] = current_user.id
        #creating sent item
        Message.create_message(msg)
        
        #creating inbox
        msg[:viewable_to] = to.id
        msg[:msgtype] = "inbox"
        new_msg = Message.create_message(msg)
        params[:msg][:link] = message_url(new_msg)

        UserMailer.deliver_send_message(current_user, to, params[:msg])
        render :text => "success"
      end
    end
  end  

  def index
    msg_type = params[:f]
    case msg_type
    when 'refer'
      messages = Message.get_messages(current_user, 'refer', params[:page])
      @page_title = "Referral messages"
    when 'sent'
      messages = Message.get_messages(current_user, 'sent', params[:page])
      @page_title = "Sent messages"
    else
      #inbox
      messages = Message.get_messages(current_user, 'inbox', params[:page])
      @page_title = "Inbox"
    end
    @messages =  messages.empty? ? {} : messages.group_by(&:message_thread_id)
  end
  
  def show
    @msg = Message.find(params[:id]) rescue nil

    unless @msg.nil?
      @msg.read_at = Time.now.to_date
      @msg.save

      if current_user == @msg.receiver
        msg_threads = Message.find(:all, :conditions => ["to_id = ? AND message_thread_id = ? AND msgtype='inbox' AND read_at IS NULL", @msg.to_id, @msg.message_thread_id])
        msg_threads.each do |mt|
          mt.read_at = Time.now.to_date
          mt.save
        end
      end
    else
      flash[:error] = "Message does not exists"
      redirect_to messages_path
    end
  end
  
  def reply
    to = User.find(params[:msg][:to_id])
    inbox_item = Message.create_message(params[:msg])
    params[:msg][:msgtype] = "sent"
    params[:msg][:viewable_to] = current_user.id
    sent_item = Message.create_message(params[:msg])
    inbox_item.body = inbox_item.body.gsub("<br/>", "\n")

    UserMailer.deliver_send_reply(current_user, to, inbox_item)
    render :text => render_to_string(:partial => "messages/msg", :locals => {:msg => inbox_item})
  end
  
  def delete
    m = Message.find(params[:id])
    m.destroy
    render :nothing => true
  end
  
end