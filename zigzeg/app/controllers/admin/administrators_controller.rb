class Admin::AdministratorsController < ApplicationController
  layout "admin"
  before_filter :authenticate
  before_filter :admin_authenticate
  before_filter :admin_updates_checker

  def index
    @admins = User.get_administrators(params[:page])
  end

  def show
  end

  def create
    if request.post?
      begin
        @user = User.create_update(params[:user])
        @user.update_attribute(:status, true)
        redirect_to admin_administrators_path
      rescue Exception => e
        flash[:error] = e.message.to_s
        redirect_to new_admin_administrators_path
      end
    end
  end

  def update
    if request.put?
      begin
        @user = User.find(params[:id])
        unless @user.nil?
          params[:user][:password] = Helper.encrypt_password(params[:user][:password])
          params[:user][:password_confirmation] = Helper.encrypt_password(params[:user][:password_confirmation])
          @user.update_attributes!(params[:user])
        end
        redirect_to admin_administrators_path
      rescue Exception => e
        flash[:error] = e.message.to_s
        redirect_to admin_administrators_path
     end
   end
  end

  def edit
    @user = User.find(params[:id])
  end

  def remove_admins
    js_string = ""
    unless params[:ids].blank?
      User.where("id IN (?) AND id !=1", params[:ids].split(",")).delete_all
      params[:ids].split(",").each do |id|
        js_string += "$('.admins_row_#{id}').fadeOut(function(){ $(this).remove()});"
      end
    end
    render :js => js_string
  end

end
