class  ContactsController < ApplicationController
  layout 'login_manage'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :contact_password

  before_filter :authenticate, :except => [:confirm]
  before_filter :load_contact_lists, :only => [:index]
  
  def index
    @contacts = []
    unless params[:list].nil?
      clist = ContactList.find(params[:list]) rescue nil
      unless clist.nil?
        ids = clist.users_contact_lists.map(&:contact_user_id)
        @contacts = User.find(:all, :conditions => ["id IN (?)", ids])
        @selected_contact_list = [clist.name, clist.id]
      else
        redirect_to contacts_path
      end
    else
      @contacts = current_user.contact_users
    end
  end

  def accept_invitation
    invitation = Invitation.find(params[:id]) rescue nil

    unless invitation.nil?
      Contact.add_contact(current_user, invitation.user)
      UserMailer.deliver_accepted_invitation(current_user, invitation.user)
      invitation.destroy
      render :nothing => true
    end
  end
  
  def cancel_invitation
    Invitation.delete(params[:id]) rescue nil
    render :nothing => true
  end
  
  def resend_invitation
    invitation = Invitation.find(params[:id]) rescue nil

    unless invitation.nil?
      confirm_link = confirm_url(:token => invitation.token)
      UserMailer.deliver_send_request(current_user, invitation, confirm_link)
      render :text => "Invitation sent successfully."
    else
      render :text => "Invitation not found."
    end
  end
  
  def new
    @contact = Contact.new
  end
  
  def friends
    @contacts = current_user.contact_users
    #current_user.friends_of_friends
  end

  def friend_requests
    @invites = Invitation.friend_requests(current_user)
  end

  def your_requests
    @invites = Invitation.your_requests(current_user)
  end
  
  def show_add_list
    add_list_form = render_to_string :partial => "contacts/show_add_list"
    render :text => add_list_form
  end

  def show_edit_list
    edit_list_form = render_to_string :partial => "contacts/show_edit_list"
    render :text => edit_list_form
  end

  def remove_user_fromlist
    ucl = UsersContactList.find_by_contact_list_id_and_contact_user_id(params[:id], params[:user_id])
    ucl.destroy
    render :nothing => true
  end
  
  def delete_fromlist
    ids = params[:contact_list_id].keys
    ContactList.destroy_all(["id IN (?)", ids])
    render :nothing => true
  end
  
  def create_list
    cl = ContactList.create(:name => params[:name], :user_id => current_user.id)
    user_ids = params[:users_id].keys
    user_ids.each do |uid|
      UsersContactList.create(
        :user_id => current_user.id,
        :contact_list_id => cl.id,
        :contact_user_id => uid
      )
    end
    render :nothing => true
  end
  
  
  def send_request
    new_user = User.find_by_email(params[:contact_email]) rescue nil
    unless new_user.nil?
      if current_user.not_friends_with?(new_user)
        if Invitation.no_existing_request?(current_user, params[:contact_email])
          #create
          params[:user_id] = current_user.id
          params[:token] = Helper::generate_token
          begin
            invitation= Invitation.create_invite(params)
          rescue Exception => e
            flash[:error] = e.message.to_s
            redirect_to new_contact_path
            return
          end
        else
          #duplicate request
          flash[:error] = "You have already requested this person."
          redirect_to new_contact_path
          return
        end
      else
        #friends already
        flash[:error] = "You are already friends with this person."
        redirect_to new_contact_path
        return
      end
    else
      if Invitation.no_existing_request?(current_user, params[:contact_email])
        #create
        params[:user_id] = current_user.id
        params[:token] = Helper::generate_token
        begin
          invitation = Invitation.create_invite(params)
        rescue Exception => e
          flash[:error] = e.message.to_s
          redirect_to new_contact_path
          return
        end
        
      else
        invitation = Invitation.find_by_email(params[:contact_email])
      end
    end
    
    confirm_link = confirm_url(:token => invitation.token)
    UserMailer.deliver_send_request(current_user, invitation, confirm_link)
    flash[:notice] = "You have successfully send an invitation to #{invitation.firstname}."
    redirect_to contacts_path
  end
  
  private
  
  def load_contact_lists
    @contact_lists = [['Show all',nil]]
    current_user.contact_lists.each do |cl|
      @contact_lists << [cl.name, cl.id]
    end
  end

end