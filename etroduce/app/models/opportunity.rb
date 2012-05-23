class Opportunity < ActiveRecord::Base

  belongs_to :user
  belongs_to :category  
  has_many :assets, :dependent => :destroy
  serialize :notify_contact_list

  validates_presence_of :subject, :category_id, :description, :zipcode
  validates_length_of :subject, :maximum => 254

  class << self
    def unpublished(page=nil)
      paginate :page => page,
               :per_page => 10,
               :conditions => ["status=0"],
               :order => "created_at DESC"      
    end
    
    def myopportunities(user, search_str='', page, country)
      paginate :page => page,
               :per_page => 20,
               :conditions => ["user_id=? AND (subject LIKE ? OR description LIKE ?) AND country = ?", user.id, "%#{search_str}%", "%#{search_str}%", country],
               :order => "created_at DESC",
               :include => :category
    end
    
    def friends_post(user, search_str='', page, country)
      ids = user.contacts.map(&:contact_user_id)
      paginate :page => page,
               :per_page => 20,
               :conditions => ["status=1
                                AND user_id IN (?) 
                                AND (subject LIKE ? OR description LIKE ?)
                                AND country = ?", 
                              ids, "%#{search_str}%", "%#{search_str}%", country],
               :order => "created_at DESC",
               :include => :category
    end

    def friends_of_friends_post(user, search_str='', page, country)
      ids = user.contacts.map(&:contact_user_id)
      ids.each do |id|
        u = User.find(id) rescue nil
        ids += u.contacts.map(&:contact_user_id) unless u.nil?
      end
      ids.uniq!
      ids = ids - [user.id]
      paginate :page => page,
               :per_page => 20,
               :conditions => ["status=1
                                AND user_id IN (?) 
                                AND (subject LIKE ? OR description LIKE ?)
                                AND country = ?",
                              ids, "%#{search_str}%", "%#{search_str}%", country],
               :order => "created_at DESC",
               :include => :category
    end
    
    def get_public(cat=nil, search_str=nil, page=1, per_page=15, country)
      category = Category.find_by_code(cat) rescue nil

      unless category.nil?
        opps = Opportunity.paginate(:page => page,
                                    :per_page => per_page,
                                    :conditions => ["status=1 
                                                     AND category_id = ? 
                                                     AND privacy = 3 
                                                     AND (subject LIKE ? OR description LIKE ?) AND country = ?",
                                                   category.id, "%#{search_str}%", "%#{search_str}%", country],
                                    :order => "created_at DESC",
                                    :include => :category)
      else
        opps = Opportunity.paginate(:page => page,
                                    :per_page => per_page,
                                    :conditions => ["status=1 
                                                     AND privacy = 3 
                                                     AND (subject LIKE ? OR description LIKE ?) 
                                                     AND country = ?",
                                                   "%#{search_str}%", "%#{search_str}%", country],
                                    :order => "created_at DESC",
                                    :include => :category)
      end
      opps
    end
    
  end
  
  def short_description
    unless self.description.nil?
      if self.description.length > 85
        "#{self.description.to_s[0, 85]} ..."
      else
        "#{self.description}"
      end
    end
  end
end
