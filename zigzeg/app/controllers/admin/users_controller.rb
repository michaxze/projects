class Admin::UsersController < ApplicationController
  layout 'admin_users'
  before_filter :admin_authenticate

  def confirm
    u = User.find(params[:id])
    u.update_attribute(:status, 1)
  end
    
  def index
    @users = User.regular_users
    @users_count = @users.length
  end
  
  def userdetails
    @user = User.find(params[:id])
  end
  
  def suspend
    if request.post?
      @user = User.find(params[:id])
      @user.status = 2
      @user.save!
      SuspendedAccount.create!(:user_id => @user.id, :reason_code => params[:stype], :created_by => current_user.id)
      Resque.enqueue(Suspended, @user.id)
    end
    
    render :nothing => true
  end
  
  def activate
    @user = User.find(params[:user_id])
    @user.update_attribute(:status, 1)
    redirect_to userdetails_admin_user_path(@user)
  end
end
