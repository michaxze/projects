class Account::MessagesController < ApplicationController
  layout "user_cms"
  before_filter :authenticate
  before_filter :user_top_checker

  def index
    @page_title = "Message Box - "+current_user.name_or_email.titleize rescue ''
    @unread_messages = current_user.messages.unread
    @messages = current_user.messages.get_messages

    page = params[:page] || 1
    @msg = current_user.messages.paginate(:page => 1, :per_page => 15)
    @msg_sorted = current_user.messages.get_messages(page)
  end

  def show
     @page_title = "Message Box - "+current_user.name_or_email.titleize rescue ''
    if has_permission?
      @message = Message.find(params[:id])
      @message_threads = @message.threads
      #@message.update_attribute(:is_viewed, true)
      #@message.threads.each {|mt| mt.update_attribute(:is_viewed, true)}      
      render :partial => "show", :layout => false
    else
      render :text => "Sorry! You dont have permission to view this message", :layout => false
    end
  end

  def remove_messages
    js_string = ""
    current_user.messages.where("id IN (?) ", params[:ids].split(",")).each{ |m| m.delete_mthreads }
    params[:ids].split(",").each do |id|
      js_string += "$('.message_row_#{id}').fadeOut(function(){ $(this).remove()});"
    end
    render :js => js_string
  end

  def create
    receiver = User.find(params[:receiver_id])

    @message = Message.new
    @message.receiver = receiver
    @message.sender = current_user
    if params[:message_thread_id].nil?
      thread = MessageThread.new
      thread.sender = current_user
      thread.receiver = receiver
      thread.save!
      @message.message_thread_id = thread.id
    else
      @message.message_thread_id = params[:message_thread_id]
    end
    @message.contents = params[:content]
    @message.subject = params[:subject]
    @message.viewer = receiver
    @message.msgtype = 'inbox'
    @message.save!

    sent = @message.clone
    sent.msgtype = 'sent'
    sent.is_viewed = true
    sent.viewer = current_user
    sent.save!

    if receiver.notify_updates_everytime?
      Resque.enqueue(Smailer, @message.id)
    end

    render :text => render_to_string( :partial => "message_row", :locals => { :msg => @message })
  end

  def ajax_get_message_threads
    @message = Message.find(params[:id])
    @messages = @message.threads[5..-1]
    render :text => render_to_string(:partial => "message_row", :collection => @messages, :as => :msg)
  end

  def reply_contactus
    contactus_msg = Message.find(params[:id])
    msg = Message.new
    msg.subject = contactus_msg.subject
    msg.contents = params[:contents]
    msg.viewer = current_user
    msg.msgtype= "contactus_sent"
    msg.parent_id = contactus_msg.id
    msg.save!

    Resque.enqueue(Contactus, msg.id)
    render :partial => "thread_row", :locals => { :msg => msg }
  end

  private
    def has_permission?
      msg = Message.find(params[:id])
      return false if msg.nil?
      return false if msg.viewer_id !=  current_user.id
      true
    end
end
