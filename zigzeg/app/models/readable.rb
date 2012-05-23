class Readable < ActiveRecord::Base
  belongs_to :readable, :polymorphic => true
  belongs_to :reader, :polymorphic => true

  class << self
    def create_new(user, place, readable)
      res = Readable.where("reader_id=? AND reader_type=? AND readable_id=? AND readable_type=?", user.id, user.class.name, readable.id, readable.class.name)

      if res.empty?
        # posting = place, event, deal
        read =  Readable.new
        read.reader = user
        read.readable = readable
        read.place_id = place.id
        read.save
      end
    end
  end
end
