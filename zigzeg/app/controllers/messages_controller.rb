class MessagesController < ApplicationController
  layout "user_cms"
  before_filter :authenticate
  before_filter :get_new_post, :only => [:show]
  before_filter :get_recommendations, :only => [:index, :general, :personal, :picture, :education, :contact, :settings]
  before_filter :check_permission, :only  => [ :show ]

  def index
    @messages = current_user.messages.get_messages(params[:page])
  end

  def show
    @message = Message.find(params[:id])
    @message_threads = @message.threads
  end

  def create
    receiver = User.find(params[:receiver_id])

    @message = Message.new
    @message.receiver = receiver
    @message.sender = current_user
    if params[:thread_id].nil?
      thread = MessageThread.new
      thread.sender = current_user
      thread.receiver = receiver
      thread.save!
      @message.message_thread_id = thread.id
    else
      @message.message_thread_id = params[:thread_id]
    end
    @message.contents = params[:contents]
    @message.viewer = receiver
    @message.msgtype = 'inbox'
    @message.save!

    sent = @message.clone
    sent.msgtype = 'sent'
    sent.is_viewed = true
    sent.viewer = current_user
    sent.save!

    render :text => render_to_string( :partial => "thread_row", :locals => { :msg => @message })
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
    def check_permission
      msg = Message.find(params[:id])
      redirect_to messages_path if msg.nil?
      redirect_to messages_path unless msg.receiver_id !=  current_user.id
    end
end
