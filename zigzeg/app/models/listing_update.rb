class ListingUpdate < ActiveRecord::Base
  belongs_to :updateable, :polymorphic => true
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :place_id
  validates_presence_of :section
  validates_presence_of :action_name
  validates_presence_of :updateable_id
  validates_presence_of :updateable_type

  class << self
    def get_place_id(object)
      case object.class.name
      when "Place"
        return object.id
      when "Event", "Deal"
        return object.place.id
      when "Shout"
        if object.shoutable.class.name == "Place"
          return object.shoutable.id
        else
          return object.shoutable.place.id
        end
      else
        object.id
      end
    end

    def create_new(user, updateable, params)
      sections = [
        Constant::COMPANY_NAME,
        Constant::OPERATING_HOURS,
        Constant::ADDRESS,
        Constant::NEW_IMAGES,
        Constant::NEW_FEATURES,
        Constant::AN_EVENT,
        Constant::AN_OFFER
      ]

      if sections.include?(params[:section])
        found = ListingUpdate.where("section = ? AND updateable_id = ? AND updateable_type = ? AND DATE_FORMAT(created_at, '%Y-%m-%d') = ?", params[:section], updateable.id, updateable.class.name, Time.now.strftime("%Y-%m-%d"))

        if found.empty?
          lu = ListingUpdate.new
          lu.updateable = updateable # place, events, deals
          lu.user_id = user.id
          lu.place_id = get_place_id(updateable)
          lu.section = params[:section]
          lu.action_name = params[:action_name]
          lu.shown = params[:shown] unless params[:shown].nil?

          if lu.save!
            return  lu
          else
             return nil
          end
        else
          return nil
        end
      else
        #shoul notify once only
        if params[:action_name] == Constant::EXPIRING
          found = ListingUpdate.where("section = ? AND updateable_id = ? AND updateable_type = ?", params[:section], updateable.id, updateable.class.name).first

          if found.nil?
            lu = ListingUpdate.new
            lu.updateable = updateable # place, events, deals
            lu.user_id = user.id
            lu.place_id = get_place_id(updateable)
            lu.section = params[:section]
            lu.action_name = params[:action_name]
            lu.save
          end
        else
          lu = ListingUpdate.new
          lu.updateable = updateable # place, events, deals
          lu.user_id = user.id
          lu.place_id = get_place_id(updateable)
          lu.section = params[:section]
          lu.action_name = params[:action_name]
          lu.shown = params[:shown] unless params[:shown].nil?
          if lu.save!
            return  lu
          else
            return nil
          end
        end
      end

    end
  end

end
