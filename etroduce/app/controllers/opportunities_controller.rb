class  OpportunitiesController < ApplicationController
  layout 'login_opp'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :authenticate, :except => [ :view, :show, :index, :show_respond_na, :send_respond_na ]

  def remove_image
    asset = Asset.find(params[:id])
    asset.destroy
    render :nothing => true
  end
  
  def show_all_opportunities
    user = User.find(params[:user_id])
    opps = user.opportunities.find(:all, :conditions => ["status=1"])
    ret = render_to_string(:partial => "opportunities/opps_profile", :locals => { :opportunities => opps })
    render :text => ret
  end

  def search_byname
    #TODO: move the searching to model level
    str = params[:tag].to_s
    ids = current_user.contacts.map(&:contact_user_id)
    users = User.find(:all, :conditions => ["(firstname like ? OR lastname like ? OR email like ?) AND id IN (?) AND id <> ?",
            "%#{str}%", "%#{str}%", "%#{str}%", ids, current_user.id])

    users_list = []
    users.each do |u|
      users_list << { :key => u.email.downcase, :value => "#{u.fullname.downcase}" }
    end

    render :text => users_list.to_json
  end
  
  def search_email
    #TODO: move the searching to model level
    str = params[:tag].to_s
    ids = current_user.contacts.map(&:contact_user_id)
    users = User.find(:all, :conditions => ["(firstname like ? OR lastname like ? OR email like ?) AND id IN (?) AND id <> ?",
            "%#{str}%", "%#{str}%", "%#{str}%", ids, current_user.id])

    users_list = []
    users.each do |u|
      users_list << { :key => u.email.downcase, :value => "#{u.email.downcase}" }
    end

    render :text => users_list.to_json
  end
  
  def show
    @opp = Opportunity.find(params[:id]) rescue nil
    if @opp.nil?
      flash[:error] = "Post does not exist."
      redirect_to root_path
    else
      @opp.increment!(:views)
    end
  end

  def show_respond_na
    opp = Opportunity.find(params[:id])
    render :text => render_to_string(:partial => "show_respond_na", :locals => { :opp => opp})
  end
  
  def show_respond
    opp = Opportunity.find(params[:id])
    render :text => render_to_string(:partial => "show_respond", :locals => { :opp => opp})
  end

  def show_refer
    opp = Opportunity.find(params[:id])
    render :text => render_to_string(:partial => "show_refer", :locals => { :opp => opp})
  end

  def show_share
    opp = Opportunity.find(params[:id])
    render :text => render_to_string(:partial => "show_share", :locals => { :opp => opp})
  end

  def share
    opp = Opportunity.find(params[:opp_id])
    copy = opp.clone
    copy.remarks = params[:message]
    copy.parent_post_id = opp.id
    copy.user_id = current_user.id
    copy.privacy = 1
    copy.save
    render :text => "success"
  end
  
  def send_refer
    ref_email =  params[:referred_email].first rescue ''
    if ref_email.blank?
      params[:referred_email] = [params[:email_unresolved]]
    end
    
    if params[:referred_email].blank?
      render :text => "Please enter your friends' email address."
    elsif params[:subject].blank?
      render :text => "Please fill up subject field."
    elsif params[:body].blank?
      render :text => "Please fill up message"
    else
      opp = Opportunity.find(params[:opp_id])
      message = Message.send_respond(current_user, opp.user, params)

      params[:message] = params[:body].gsub("\n", "<br/>")
      params[:mlink] = messages_url(:id => message.id).to_s
      UserMailer.deliver_send_refer(current_user, opp, message, params)
      render :text => "success"
    end
  end
  
  def send_respond
    if params[:subject].blank?
      render :text => "Please fill up subject field."
    elsif params[:body].blank?
      render :text => "Please fill up message"
    else
      opp = Opportunity.find(params[:opp_id])
      message = Message.send_respond(current_user, opp.user, params)

      params[:message] = params[:body].gsub("\n", "<br/>")
      params[:mlink] = messages_url(:id => message.id).to_s
      UserMailer.deliver_send_respond(current_user, opp.user, message, params)
      render :text => "success"
    end
  end
  
  def send_respond_na
    if params[:subject].blank?
      render :text => "Please fill up subject field."
    elsif params[:body].blank?
      render :text => "Please fill up message"
    else
      opp = Opportunity.find(params[:opp_id])
      user = User.find_by_email(params[:email]) rescue nil

      unless user.nil?
        message = Message.send_respond(user, opp.user, params)
        params[:message] = params[:body].gsub("\n", "<br/>")
        params[:mlink] = messages_url(:id => message.id).to_s
        UserMailer.deliver_send_respond(user, opp.user, message, params)
      else
        user_params = {}
        user_params[:firstname] = params[:firstname]
        user_params[:lastname] = params[:lastname]
        user_params[:email] = params[:email]
        user_params[:username] = Helper::generate_username
        user_params[:password] = Helper::generate_password
        user = User.create_user(user_params)

        message = Message.send_respond(user,opp.user, params)
        params[:message] = params[:body].gsub("\n", "<br/>")
        params[:mlink] = messages_url(:id => message.id).to_s
        activate_link = activate_na_url(:token => user.registration_token.to_s)
        UserMailer.deliver_send_respond(user, opp.user, message, params)
        UserMailer.deliver_send_invite_na(user, activate_link, params)
      end

      render :text => "success"
    end
  end

  def index
    @opportunities = Opportunity.get_public(params[:c], params[:search_str], params[:page], nil, @country)
  end

  def jobs
    @opportunities = Opportunity.get_public_and_yours(current_user, Category.find_by_code('jobs'))
  end
  def personals
    @opportunities = Opportunity.get_public_and_yours(current_user, Category.find_by_code('personals'))
  end
  def forsale
    @opportunities = Opportunity.get_public_and_yours(current_user, Category.find_by_code('forsale'))
  end
  def housing
    @opportunities = Opportunity.get_public_and_yours(current_user, Category.find_by_code('housing'))
  end
  def deals
    @opportunities = Opportunity.get_public_and_yours(current_user, Category.find_by_code('dailydeals'))
  end
  
  def view
    opp = Opportunity.find(params[:id])
    str = render_to_string(:partial => "view_opp", :locals => { :opp => opp })
    render :text => str
  end
end