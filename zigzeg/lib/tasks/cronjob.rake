require 'yaml'

namespace :cronjob do

  #send email to users who have settings to get udpates 'perday'
  task :send_email_updates => :environment do
    users = User.where("status=1 AND settings like ?", "%notify_updates: perday%")
    users.each do |user|
      puts user.name_or_email
      if user.notify_updates_perday?
        Resque.enqueue(UpdatesSender, user.id)
      end
    end
  end

  # - send notification updates for offers about to expire in 2 days
  # - send notifications updates for events about to start in 2 days
  task :offer_event_notification  => :environment do
    Deal.where("status='published' AND ongoing <> 1").each do |deal|
      puts "Reading offer: #{deal.name}..."
      unless deal.end.nil?
        daysahead = (Time.now + 2.day).to_date
        puts "#{deal.id} - #{deal.end.to_date} - #{daysahead}"
        if deal.end  == daysahead
          param = { :section => Constant::OFFER , :action_name => Constant::EXPIRING }
          ListingUpdate.create_new(deal.user, deal, param)
          ApplicationController.new.broadcast("/account")
        end
      end
    end

    Event.where("status IN ('published') AND event_type IN('2','1')").each do |event|
      puts "Reading event: #{event.name}..."
      unless event.start_date.nil?
        daysahead = (Time.now + 2.day).to_date
        puts "#{event.id} - #{event.start_date} - #{daysahead}"
        if event.start_date  == (Time.now + 2.day).to_date
          param = { :section => Constant::EVENT, :action_name => Constant::STARTING }
          ListingUpdate.create_new(event.user, event, param)
          ApplicationController.new.broadcast("/account")
        end
      end
    end

  end

  # this will check listing updates that are already 24 hours old and show them to users listing updates
  # - will only process those 2 days old updates
  task :check_listing_updates => :environment do
    puts "Checking listing updates that are 2 days old..."
    ListingUpdate.where("shown = 0 AND (DATE_FORMAT(created_at, '%Y-%m-%d') < ? AND DATE_FORMAT(created_at, '%Y-%m-%d') >= ? )", Time.now.strftime("%Y-%m-%d"), (Time.now - 2.days).strftime("%Y-%m-%d") ).each do |lu|
      puts lu.inspect
      lu.update_attribute(:shown, true)
    end
    puts "Done..."
  end

  task :check_expired_listings => :environment do
    puts "Checking for expired events and deals/offers..."

    Event.where("status IN ('published', 'deleted')").each do |event|
      case event.event_type
      when "1"
        puts  "#{event.start_date} < #{Time.now.to_date}"
        unless event.listing.nil?
          if event.start_date < Time.now.to_date
            event.listing.update_attribute(:status, 2)
            event.listing.update_attribute(:ranking, 0)
            event.update_attribute(:sort_status, 4)
            event.update_attribute(:status, 'expired')
            Listings.remove_listing_updates(event)
          end
        end
      when "2"
        puts  "#{event.end_date} < #{Time.now.to_date}"
        unless event.listing.nil?
          if event.end_date < Time.now.to_date
            event.listing.update_attribute(:status, 2)
            event.listing.update_attribute(:ranking, 0)
            event.update_attribute(:sort_status, 4)
            event.update_attribute(:status, 'expired')
            Listings.remove_listing_updates(event)
          end
        end
      when "3"
        # do nothing
      when "4"
        # do nothing
      end

      if event.status == "deleted"
        event.listing.update_attribute(:status, 3)
        event.listing.update_attribute(:ranking, 0)
      end
    end

    Deal.where("status IN ('published','complete', 'deleted') ").each do |deal|
      unless deal.start.nil?
        unless deal.listing.nil?
          puts "#{deal.listing.published_at} == #{Time.now}"
          puts "#{deal.id} #{deal.name} -- #{deal.mystatus.inspect}"

          if ["complete", "published"].include?(deal.status)
            #expired already
            puts "expired.."
            if deal.start.to_date < Time.now.to_date
              unless deal.end.nil?
                if deal.end.to_date < Time.now.to_date
                  deal.listing.update_attribute(:status, 2)
                  deal.listing.update_attribute(:ranking, 0)
                  deal.update_attribute(:sort_status, 4)
                  deal.update_attribute(:status, 'expired')
                  Listings.remove_listing_updates(deal)
                end
              end
            else
              if deal.start.to_date == Time.now.to_date
                if deal.listing.status != 1
                  puts "going live..."
                  deal.listing.update_attribute(:status, 1)
                  deal.listing.update_attribute(:published_at, Time.now)
                  deal.update_attribute(:status, "published")

                  param = { :section => Constant::NEW_OFFER , :action_name => Constant::ADDED }
                  ListingUpdate.create_new(deal.user, deal, param)
                  ApplicationController.new.broadcast("/account")
                end
              end
            end
          end

          if deal.status == "deleted"
            deal.listing.update_attribute(:status, 3)
            deal.listing.update_attribute(:ranking, 0)
          end

        end
      end
    end

    subj = "Cronjob: Done checking for expired events and deals"
    msg = "It's easy to update it... :)"
    Mailer.notify_admin("michaxze@gmail.com", msg, subj).deliver
  end

  task :clean_listings => :environment do
    puts "Clearing listings with no places assigned..."

    Listing.all.each do |listing|
      unless listing.listable.nil?
        listing.update_attribute(:name, listing.listable.name)
      else
        listing.delete if listing.listable.nil?
      end
    end
    puts "Done cleaning..."
  end

end
