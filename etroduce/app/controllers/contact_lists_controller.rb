class ContactListsController < ApplicationController
  layout 'login_manage'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authenticate

  def create
    begin
      cl = ContactList.create!(params[:contact_list])
      render :text => cl.id
    rescue Exception => e
      render :text => e.message.to_s
    end
  end

  def show
    #lazy mode
    @contact_list = ContactList.find(params[:id])

    ucl = UsersContactList.find(:all, :conditions => ["user_id = ? AND  contact_list_id = ?", @contact_list.user_id, params[:id]])
    ucl_ids = ucl.map(&:contact_user_id).uniq

    @current_users_list = ucl
  end
  
  def index
    
  end

  def add_contacts
    #lazy mode
    user_ids = []
    ucl = UsersContactList.find(:all, :conditions => ["user_id = ? AND  contact_list_id = ?", current_user.id, params[:contact_list_id]])
    ucl_ids = ucl.map(&:contact_user_id).uniq
    params[:contacts].each{|i| user_ids << i.to_i}
    new_ids = user_ids - ucl_ids
    puts ucl_ids.inspect
    puts user_ids.inspect
    
    new_ids.each do |id|
      UsersContactList.create!(:user_id => current_user.id, :contact_list_id => params[:contact_list_id], :contact_user_id => id)
    end
    
    redirect_to contact_list_path(:id => params[:contact_list_id])
  end

  def remove_contacts
    #lazy mode
    params[:contacts].each do |id|
      UsersContactList.delete(id)
    end
    
    redirect_to contact_list_path(:id => params[:contact_list_id])    
  end
  
end
