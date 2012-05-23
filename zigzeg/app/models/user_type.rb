class UserType < ActiveRecord::Base
  
  validates_uniqueness_of :code
  
  def self.create_update(params)
    ut = UserType.find_by_code(params[:code]) || UserType.new
    ut.name = params[:name]
    ut.code = params[:code]
    ut.save!
  end

end
