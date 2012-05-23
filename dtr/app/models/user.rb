class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  def current_daytime
    time = Time.now
    result = DailyTime.where("user_id = ? AND DATE_FORMAT(created_at, '%Y-%m-%d') = ?", self.id, time.strftime("%Y-%m-%d")).first
    result
  end
end
