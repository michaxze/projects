class Blog < ActiveRecord::Base
  has_many :assets, :as => :uploadable
  validates_presence_of :title, :contents 
  
  after_create :update_code
  
  def update_code
    code = Helper.clean_code(self.title)
    self.update_attribute(:page_code, code)
  end
  
end
