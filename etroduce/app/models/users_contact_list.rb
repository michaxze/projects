class UsersContactList < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact_list
  
  def contact_user
    User.find(self.contact_user_id)
  end
  
end