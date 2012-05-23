class MessageThread < ActiveRecord::Base
  belongs_to :sender, :polymorphic => true
  belongs_to :receiver, :polymorphic => true

  class << self
    def create_ifnone(sender, receiver)
      mt = MessageThread.find_by_sender_id_and_receiver_id(sender.id, receiver.id) || MessageThread.new(:sender => sender, :receiver => receiver)
      mt.save!
      mt
    end

    def create_thread(sender, receiver)
      mt = MessageThread.new(:sender => sender, :receiver => receiver)
      mt.save!
      mt
    end

  end
end
