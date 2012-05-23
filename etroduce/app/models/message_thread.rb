class MessageThread < ActiveRecord::Base
  has_many :messages
  
  def referred_user
    unless self.referred_email.nil?
      user = User.find_by_email(self.referred_email) rescue nil
      return user if user
      nil
    else
      nil
    end
  end
  
end