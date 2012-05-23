class  MyopportunitiesController < ApplicationController
  layout 'login_manage'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :get_categories, :only => [:new, :edit]
  before_filter :authenticate
  before_filter :get_contact_list_select, :only => [:new]
  uses_tiny_mce

  def show
    @opp = Opportunity.find(params[:id]) rescue nil
    if @opp.nil?
      flash[:error] = "Post does not exist."
      redirect_to root_path
    end
  end
  
  def index
    if params[:p].to_s == 'f'
      @opportunities = Opportunity.friends_post(current_user, params[:search_str], params[:page], @country)
    elsif params[:p].to_s == 'ff'
      @opportunities = Opportunity.friends_of_friends_post(current_user, params[:search_str], params[:page], @country)
    else
      @opportunities = Opportunity.myopportunities(current_user, params[:search_str], params[:page], @country)
    end
  end

  def new
    @opportunity = Opportunity.new
    @opportunity.country = "US"
    @opportunity.category_id = @categories.first.id
  end
  
  def create
      @opportunity = Opportunity.new(params[:opportunity])
      @opportunity.subdomain = session[:sub_domain]
    begin
      @opportunity.privacy = params[:privacy]
      @opportunity.country = params[:country]
      @opportunity.user_id = current_user.id
      @opportunity.post_type = params[:post_type] unless params[:post_type].nil?

      unless params[:opportunity][:expire_at].nil?
        unless params[:opportunity][:expire_at].blank?
          @opportunity.expire_at = params[:opportunity][:expire_at].to_date
        else
          @opportunity.expire_at = (Time.now + 90.days).to_date
        end
      end

      if !params[:notify_all_contact].blank?
        @opportunity.notify_contact_list = ["all"]
      elsif !params[:notify_contact_list].blank?
        @opportunity.notify_contact_list = params[:notify_contact_list]
      end
        
      @opportunity.status = 1 if admin?(current_user)
      @opportunity.save!

      unless params[:image].nil?
        params[:image].each do |img|
          a = Asset.new
          a.image = img
          a.opportunity_id = @opportunity.id
          a.created_by = current_user.id
          a.save!
        end
      end
    
      if !admin?(current_user)
        url = opportunity_url(@opportunity)
        UserMailer.deliver_notify_admin('new_post', @opportunity, url)
      end

      flash[:notice] = "Opportunity successfully created."
      if @opportunity.post_type == "personal"
        redirect_to myopportunities_path
      else
        @opportunity.status = -1 # need to proceed to payment
        LineItem.create!(:cart => current_cart, :opportunity => @opportunity, :quantity => 1, :unit_price => UNIT_PRICE)
        redirect_to current_cart_url
      end
    rescue Exception => e
      flash[:error] = e.message
      redirect_to new_myopportunity_path
    end
  end
  
  def update
    @opportunity = Opportunity.find(params[:id])
    @opportunity.update_attributes(params[:opportunity])
    @opportunity.country = params[:country]
    @opportunity.privacy = params[:privacy]
    @opportunity.user_id = current_user.id
    unless params[:opportunity][:expire_at].nil?
      unless params[:opportunity][:expire_at].blank?
        @opportunity.expire_at = params[:opportunity][:expire_at].to_date
      else
        @opportunity.expire_at = Time.now.to_date
      end
    end
    
    unless params[:image].nil?
      params[:image].each do |img|
        a = Asset.new
        a.image = img
        a.opportunity_id = @opportunity.id
        a.created_by = current_user.id
        a.save
      end
    end
    
    @opportunity.save
    flash[:notice] = "Opportunity successfully updated."
    redirect_to myopportunities_path
  end
  
  def edit
    @opportunity = Opportunity.find(params[:id])
  end
  
  def destroy
    @opportunity = Opportunity.find(params[:id]) rescue nil
    unless @opportunity.nil?
      @opportunity.destroy
    end
    flash[:notice] = "Opportunity successfully deleted."
    redirect_to myopportunities_path
  end
  
  protected
  
  def get_categories
    @categories = Category.find(:all, :order => "name ASC")
  end
  
  def get_contact_list_select
    @contact_lists = current_user.contact_lists
  end
end