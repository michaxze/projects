class  AdminsController < ApplicationController
  layout 'login_manage'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authenticate_admin
  uses_tiny_mce
  
  def index
    @opportunities = Opportunity.unpublished(params[:page])
  end

  def view
    opp = Opportunity.find(params[:id])
    str = render_to_string(:partial => "view_opp", :locals => { :opp => opp })
    render :text => str
  end

  def accept
    opp = Opportunity.find(params[:id])
    opp.status = 1
    opp.save
    
    unless opp.notify_contact_list.nil?
      puts opp.notify_contact_list.inspect
      if opp.notify_contact_list.first.to_s == "all"
        opp.user.contacts.each do |c|
          unless c.user.nil?
            UserMailer.deliver_notify_newpost(opp.user, c.user, opp, opportunity_url(opp))
          end
        end
      else
        opp.notify_contact_list.each do |id|
          u = User.find(id.to_i) rescue nil
          unless u.nil?
            UserMailer.deliver_notify_newpost(opp.user, u, opp, opportunity_url(opp))
          end
        end
        
      end
    end
    render :text => "Post accepted."
  end

  def deny
    opp = Opportunity.find(params[:id])
    opp.status = 2
    opp.save
    render :text => "Post denied."
  end

end