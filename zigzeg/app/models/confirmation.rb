class Confirmation < ActiveRecord::Base
  belongs_to :confirmable, :polymorphic => true
  belongs_to :user

  def self.create_confirmation(confirmable, params)
    c = Confirmation.find_by_username(params[:email]) || Confirmation.new
    c.token = Helper.generate_token(params[:email])
    c.username = params[:email]
    c.expire_at = Time.now + 2.days
    c.confirmable = confirmable
    c.used = false
    c.save!
    c
  end

  def expired?
    ret = (self.used == true || self.expire_at.to_date < Time.now.to_date) ? true : false
    ret
  end

end
