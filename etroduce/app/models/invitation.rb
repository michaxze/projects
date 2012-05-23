class Invitation < ActiveRecord::Base
  belongs_to :user
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_presence_of :firstname, :lastname

  class << self
    def create_invite(params)
      invitation = Invitation.new
      invitation.email = params[:contact_email]
      invitation.firstname = params[:contact_firstname]
      invitation.lastname = params[:contact_lastname]
      invitation.expertise = params[:contact_expertise]
      invitation.message = params[:contact_message]
      invitation.user_id = params[:user_id]
      invitation.token = params[:token]
      invitation.save!
      invitation
    end
    
    def count_newinvites(user)
      Invitation.count(:conditions => ["email = ? AND confirmed_at IS NULL", user.email])
    end

    def friend_requests(user)
      invites = Invitation.find(:all, :conditions => ["email = ? AND confirmed_at IS NULL", user.email])
    end

    def your_requests(user)
      invites = Invitation.find(:all, :conditions => ["user_id = ? AND confirmed_at IS NULL", user.id])
    end

    def no_existing_request?(user, email)
      i = Invitation.find_by_user_id_and_email(user.id, email) rescue nil
      puts i.nil?
      i.nil?
    end
  end

  
  def fullname
    "#{self.firstname.titleize} #{self.lastname.titleize}"
  end  

  def invited_has_user?
    u = User.find_by_email(self.email) rescue nil
    !u.nil?
  end
  
  def invited
    User.find_by_email(self.email) rescue nil
  end
end
