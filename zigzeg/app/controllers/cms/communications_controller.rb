class Cms::CommunicationsController < ApplicationController
  layout 'user_cms'
  before_filter :authenticate
  respond_to :html, :json, :xml

  def index
    @messages = []
    unless params[:tab].nil?
      case params[:tab].to_s
      when "con"
        @messages = Message.contactus(current_user, params[:page])
      when "adv"
        @messages = Message.from_advertisers(current_user, params[:page])
      when "mem"
        @messages = Message.from_members(current_user, params[:page])
      when "ann"
        @messages = Message.announcements(current_user, params[:page])
      when "int"
        raise "Not supported for now"
      end
    end
  end

  def show
    @message = Message.find(params[:id])
    redirect_to cms_communications_path if !Message.has_permission?(current_user, @message)
    @message_threads = @message.threads
  end

  def delete
    @message = Message.find(params[:id])
    @message.destroy unless @message.nil?
    redirect_to cms_communications_path
  end

  def new
  end

  def sent
    usertype = get_user_type(params[:tab])

    if params[:tab].to_s  == "ann"
      @messages = Message.sent_announcements(params[:page])
    elsif params[:tab].to_s == "con"
      @messages = Message.sent_contactus(params[:page])
    else
      @messages = Message.sent(current_user, usertype, params[:page])
    end
  end

  def create_announcement
    msg = Message.new
    msg.sender = current_user
    #msg.message_thread_id = MessageThread.create_ifnone(current_user, current_user).id
    msg.receiver = current_user
    msg.contents = params[:msg_contents] unless params[:msg_contents].nil?
    msg.subject = params[:subject]
    msg.msgtype = "announcement"
    msg.email_template_id = params[:email_templates] unless params[:email_templates].nil?
    msg.viewer = nil
    msg.save!

    Resque.enqueue(Announcer, msg.id, { :notify => params[:receiver] })
    advertiser = User.find(params[:ad][:advertiser_id])

    ad = Advertisement.new(params[:ad])
    ad.advertiser = advertiser unless advertiser.nil?
    ad.creator = current_user
    ad.save!

    unless params[:banner].nil?
      as = Asset.new
      as.image = params[:banner].first
      as.authorable = current_user
      as.uploadable = ad
      as.save!
    end

    redirect_to cms_communications_path(:tab => "ann")
  end

  def create
    if params[:receiver].nil?
      flash[:error] = "Specify at least one recepient"
      redirect_to new_cms_communication_path
    end

    params[:receiver].each do |user_id|
      receiver = User.find(user_id)
      unless receiver.nil?
        msg = Message.new
        msg.sender = current_user
        msg.message_thread_id = MessageThread.create_ifnone(current_user, receiver).id
        msg.receiver = receiver
        msg.contents = params[:contents]
        msg.subject = params[:subject]
        msg.msgtype = 'inbox'
        msg.viewer = nil
        msg.save!

        msgsent = msg.clone
        msgsent.msgtype = "sent"
        msgsent.is_viewed = true
        msgsent.viewer = current_user
        msgsent.save!

        Resque.enqueue(Smailer, msg.id)
        flash[:notice] = "Message successfully sent"
      end
    end

    redirect_to cms_communications_path
  end

  def ajax_fetch_user
    usertype = get_user_type(params[:type])
    users_list = []

    @users = User.where("status=1 AND user_type='#{usertype}'")
    @users.each do |u|
       users_list << { :key => u.id.to_s, :value => "#{u.fullname.downcase}" }
    end

    render :text =>  users_list.to_json
  end

  private
    def get_user_type(usertype)
      type = case usertype
      when "con"
        "contactus"
      when "adv"
        "advertiser"
      when "mem"
        "regular"
      when "adm"
        "administrator"
      end
      type
    end

end
