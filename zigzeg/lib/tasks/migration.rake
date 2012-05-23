require 'yaml'
require 'nokogiri'
require 'open-uri'

namespace :migration do

  task :update_category_column => :environment do
    Listing.all.each do |l|
      unless l.listable.place.nil?
        if l.listable.place.category.parent.nil?
          l.category_name = l.listable.place.category.name rescue ''
        else
          l.category_name = l.listable.place.category.parent.name rescue ''
          l.sub_category_name = l.listable.place.category.name rescue ''
        end
      end
      l.save
    end
  end


  task :update_page_code => :environment do
    puts "Updating pagecodes..."

    def create_unique_code(post)
      code = Helper.clean_url(post.name)

      case post.class.name
      when "Deal"
        results = Deal.where("id <> ? AND  page_code=?", post.id, code)
        unless results.empty?
          num = code.strip
          code = "#{code}" + (num.to_i + 1).to_s
        end
      when "Event"
        results = Event.where("id <> ? AND page_code=?", post.id, code)
        unless results.empty?
          num = code.strip
          code = "#{code}" + (num.to_i + 1).to_s
        end
      when "Place"
        results = Place.where("id <> ? AND page_code=?", post.id, code)
        unless results.empty?
          num = code.strip
          code = "#{code}" + (num.to_i + 1).to_s
        end
      end

      code
    end

    Listing.all.each do |l|
      pcode = create_unique_code(l.listable)
      puts "Updating #{l.name}... : #{pcode}"
      l.listable.update_attribute(:page_code, pcode)
    end

    puts "Done..."
  end

  task :update_ranking => :environment do
    puts "Updating listing ranking..."

    Listing.where("status=1").each do |l|
      rank = l.listable.user.latest_subscription.ranking rescue 0
      puts "Updating rank #{l.id} #{l.name} = #{rank}..."
      l.update_attribute(:ranking, rank)
    end

    puts "Done..."
  end

  task :update_activated_date => :environment do
    puts "Updating activated_at column from created_at column..."

    User.all.each do |u|
      puts "User: #{u.name_or_email}"
      if u.activated_at.nil?
        puts "Updating user #{u.email}..."
        u.update_attribute(:activated_at, u.created_at)
      end
    end
    puts "Done..."
  end

  task :update_published_date => :environment do
    puts "setting the empty published dates..."

    Listing.all.each do |l|
     if l.published_at.nil?
      puts "#{l.name} ..."
      l.update_attribute(:published_at, l.created_at)
      end
    end
  end

  task :setup_countries => :environment do
    lines = File.open("#{RAILS_ROOT}/lib/countries.html")
    lines.each_line do |line|
      arr = line.split(":")
      link = arr[0].gsub("</a>","")
      country_code = arr[1].strip
      country_name = arr[2].strip.gsub("\n",'')
      puts "#{country_code} - #{country_name} - #{link}"
      country = Country.find_by_code(country_code) || Country.new
      country.name = country_name
      country.code = country_code
      country.save!

      link_url = "http://geotags.com/iso3166/#{link}"
      open(link_url) {|f|
        f.each_line {|line|
          if line.include?("<br>")
            state_arr = line.split(":")
            state_code = state_arr[0].strip
            state_name = state_arr[1].gsub("<br>","").strip
            puts "STATES: #{state_code} - #{state_name}"
          end
        }
  }

    end
  end

end
