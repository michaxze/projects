class ContactList < ActiveRecord::Base
  belongs_to :user
  has_many :users_contact_lists, :dependent => :destroy
  
  validates_presence_of :name, :user_id
  validates_length_of :name, :minimum => 3
  
  def is_owner?(user)
    return false if user.nil?
    user.id == self.user_id
  end
  
end