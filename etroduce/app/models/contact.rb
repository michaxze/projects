class Contact < ActiveRecord::Base
  belongs_to :user, :foreign_key => "contact_user_id"
  
  class << self
    def add_contact(user, added_user)
      existing = Contact.find_by_user_id_and_contact_user_id(user.id, added_user.id) rescue nil
      
      if existing.nil?
        c = Contact.new
        c.user_id = user.id
        c.contact_user_id = added_user.id
        c.confirmed_at = Time.now.to_date
        c.save
      end
    end
  end
end
