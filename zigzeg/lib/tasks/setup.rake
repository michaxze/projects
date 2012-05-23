require 'yaml'

namespace :setup do

  task :load_test_data => :environment do
    puts "Checking for the test advertiser account..."
    advert = User.find_by_username("advertiser")
    raise "Test Advertiser account does not exists, run rake setup:default_data" if advert.nil?


    puts "Reading posts.yaml file"
    posts = File.open("#{RAILS_ROOT}/test/fixtures/posts.yaml")
    lists = nil
    YAML::load_documents( posts ) { |doc| lists = doc }

    lists.keys.each do |line|
      post = lists[line]
      puts post.inspect

      post['user_id'] = advert.id
      posting = Place.find_by_name("#{post['name']}") || Place.new
      #posting.update_attributes!(post)
      posting.update_attribute(:name, post['name'])
      posting.update_attribute(:description, post['description'])
      posting.update_attribute(:status, post['status'])
      posting.update_attribute(:category_id, 1)
      posting.update_attribute(:user_id, advert.id)
      posting.update_attribute(:tags, post['tags'])
      posting.update_attribute(:email, post['email']) unless post['email'].nil?
      posting.update_attribute(:page_code, Helper.clean_url(posting.name))
      posting.save!

      #populate data to listings table
      listing = Listing.new
      listing.listable = posting
      listing.listing_type = post['listing_type']
      listing.name = posting.name
      listing.description = posting.description
      listing.tags = posting.tags
      listing.status = posting.status
      listing.user_id = advert.id
      listing.save!
    end


    file = "deals.yaml"
    puts "Reading #{file} file"
    posts = File.open("#{RAILS_ROOT}/test/fixtures/#{file}")
    lists = nil
    YAML::load_documents( posts ) { |doc| lists = doc }

    lists.keys.each do |line|
      post = lists[line]
      puts post.inspect

      deal = Deal.find_by_page_code(post['page-code']) || Deal.new
      deal.name = post['name']
      deal.description = post['description']
      deal.tags = post['tags']
      deal.place_id = post['place_id']
      deal.category_id = 1
      deal.page_code = post['page_code']
      deal.locations = post['locations']
      deal.start = Time.now.to_date
      deal.end = Time.now.to_date + 90
      deal.user_id = advert.id
      deal.save!

      listing = Listing.find_by_listable_id_and_listable_type(deal.id, deal.class.name) || Listing.new
      listing.listable = deal
      listing.listing_type = 'deal'
      listing.status = 1
      listing.name = deal.name
      listing.description = deal.description
      listing.tags = deal.tags
      listing.user_id = advert.id
      listing.save!

    end


    file = "events.yaml"
    puts "Reading #{file} file"
    posts = File.open("#{RAILS_ROOT}/test/fixtures/#{file}")
    lists = nil
    YAML::load_documents( posts ) { |doc| lists = doc }

    lists.keys.each do |line|
      post = lists[line]
      puts post.inspect

      event = Event.find_by_page_code(post['page-code']) || Event.new
      event.name = post['name']
      event.description = post['description']
      event.tags = post['tags']
      event.place_id = post['place_id']
      event.category_id = 1
      event.page_code = post['page_code']
      event.schedule = post['schedule'].to_date rescue Time.now
      event.start_date = Time.now.to_date
      event.end_date = Time.now.to_date + 90
      event.status = 'published'
      event.user_id = advert.id
      event.save!

      edate = EventDate.new
      edate.event_id = event.id
      edate.date = post['dates']['date'].to_date  unless post['dates']['date'].nil?
      edate.start_time = post['dates']['start'] unless post['dates']['start'].nil?
      edate.end_time = post['dates']['end'] unless post['dates']['end'].nil?
      edate.save!
      puts edate.inspect
 
      listing = Listing.find_by_listable_id_and_listable_type(event.id, event.class.name) || Listing.new
      listing.listable = event
      listing.listing_type = 'event'
      listing.status = 1
      listing.name = event.name
      listing.description = event.description
      listing.tags = event.tags
      listing.user_id = advert.id
      listing.save!
    end


    file = "announcements.yaml"
    puts "Reading #{file} file"
    posts = File.open("#{RAILS_ROOT}/test/fixtures/#{file}")
    lists = nil
    YAML::load_documents( posts ) { |doc| lists = doc }
    user = User.find(3)
    place = Place.find(1)

    lists.keys.each do |line|
      post = lists[line]
      puts post.inspect

      h = Announcement.find_by_title(post['title']) || Announcement.new
      h.title = post['title']
      h.announceable = place
      h.contents = post['contents']
      h.contents = post['contents']
      h.announce_type = post['announce_type']
      h.user_id = user.id
      h.save!
    end


    file = "alerts.yaml"
    puts "Reading #{file} file"
    posts = File.open("#{RAILS_ROOT}/test/fixtures/#{file}")
    lists = nil
    YAML::load_documents( posts ) { |doc| lists = doc }

    lists.keys.each do |line|
      post = lists[line]
      puts post.inspect

      h = Alert.new
      h.alert_type = post['alert_type']
      h.title = post['title']
      h.description = post['description']
      h.sender = User.find_by_email("system@zigzeg.com")
      h.status = post['status']
      h.save!
    end

    file = "notifications.yaml"
    puts "Reading #{file} file"
    posts = File.open("#{RAILS_ROOT}/test/fixtures/#{file}")
    lists = nil
    YAML::load_documents( posts ) { |doc| lists = doc }

    lists.keys.each do |line|
      post = lists[line]
      puts post.inspect

      h = Notification.new
      h.user_id = post['user_id']
      h.notification_type = post['notification_type']
      h.contents = post['contents']
      h.save!
    end

    file = "map_addresses.yaml"
    puts "Reading #{file} file"
    posts = File.open("#{RAILS_ROOT}/test/fixtures/#{file}")
    lists = nil
    YAML::load_documents( posts ) { |doc| lists = doc }

    lists.keys.each do |line|
      post = lists[line]
      puts post.inspect

      h = MapAddress.new
      h.country_id = post['country_id']
      h.state_id = post['state_id']
      h.city_id = post['city_id']
      h.section_id = post['section_id']
      h.street = post['street']
      h.building_name = post['building_name']

      section = Section.find(post['section_id'])
      state = State.find(post['state_id'])
      city = City.find(post['city_id'])

      complete_address = ""
      complete_address += post['building_name'] unless post['building_name'].nil?
      complete_address += " " + post['street'] unless post['street'].nil?
      complete_address += " #{section.name}"
      complete_address += " #{section.postalcode}"
      complete_address += " #{city.name}"
      complete_address += " #{state.name}"
      complete_address += " Malaysia"

      h.complete_address = complete_address
      h.save!
    end

  end


  #default_data should be run before this
  task :load_features => :environment do
    # moved to default_data
  end


  task :default_data => :environment do

    file = "packages.yaml"
    puts "Reading #{file} file"
    posts = File.open("#{RAILS_ROOT}/test/fixtures/#{file}")
    lists = nil
    YAML::load_documents( posts ) { |doc| lists = doc }

    lists.keys.each do |line|
      post = lists[line]
      puts post.inspect

      h = Package.find_by_package_code(post['package_code']) || Package.new
      h.package_name = post['package_name']
      h.payment_frequency = post['payment_frequency']
      h.contract_length = post['contract_length']
      h.allowed_images = post['allowed_images']
      h.allowed_events = post['allowed_events']
      h.full_data_service = post['full_data_service']
      h.package_code = post['package_code']
      h.price_per_day = post['price_per_day']
      h.price_per_month = post['price_per_month']
      h.price_per_year = post['price_per_year']
      h.sales_tax = post['sales_tax']
      h.logo_on_map = post['logo_on_map']
      h.aboutus_characters = post['aboutus']
      h.allowed_shouts = post['allowed_shouts']
      h.customer_service = post['customer_service']
      h.ranking = post['ranking']
      h.save!
    end


    file = "highlights.yaml"
    puts "Reading #{file} file"
    posts = File.open("#{RAILS_ROOT}/test/fixtures/#{file}")
    lists = nil
    YAML::load_documents( posts ) { |doc| lists = doc }

    lists.keys.each do |line|
      puts line.inspect
      group_name = line
      post = lists[line]
      puts post.inspect

      post.each do |highlight|
        code = Helper.clean_code(highlight.first[0])
        name = highlight.first[0]
        image_name = highlight.first[1] rescue ''
        h = HighlightCategory.where("code = ? AND group_name = ?", code, group_name).first || HighlightCategory.new
        h.name = name
        h.code = code
        h.image = image_name
        h.group_name = group_name
        h.save!
      end
    end


    puts "\n\n\nReading categories.yaml file"
    cats = File.open("#{RAILS_ROOT}/test/fixtures/categories.yaml")
    contents = nil
    YAML::load_documents( cats ) { |doc| contents = doc }

    contents.keys.each do |key|
      puts "Creating/Finding category: #{key.to_s}"
      code = Helper.clean_code(key)
      cat = Category.where("name = ? AND parent_id IS NULL", key).first || Category.create!(:name => key.to_s, :code => code)
      unless contents["#{key}"].nil?
        unless contents["#{key}"].empty?
          contents["#{key}"].each do |s|

            if s.class == Hash
              s.each do |cf|
puts "Category feature: #{cf} ..."
                cf_name = cf.first
                cf_code = Helper.clean_code(code + "+" + cf.first)

                cat_feature = CategoryFeature.where("code = ? AND category_id=?", code, cat.id).first || CategoryFeature.new
                cat_feature.category_id = cat.id
                cat_feature.name = cf_name
                cat_feature.code = cf_code
                cat_feature.image = cf[1] rescue ''
                cat_feature.save!
              end
            else
             puts "Creating sub-category: #{s.to_s}"
              scode = "#{Helper.clean_code(s)}+#{code}"
              scat = Category.where("code = ? AND parent_id IS NOT NULL", scode).first || Category.new
              scat.name = s.to_s
              scat.code = scode
              scat.parent_id = cat.id
              scat.save!
            end
          end
        end
      end
    end

    #adding listing types
    puts "Creating Listing Types..."
    types = ["place", "event", "deal"]
    types.each { |t| ListingType.find_or_create_by_code_and_name(:code => t, :name => t.pluralize.titleize) }

    #adding user_types
    user_types = ["regular", "advertiser", "administrator", "normal_admin", "system", "sales"]
    Constant::USER_TYPES.each do|ut|
      UserType.create_update(:code => ut[1], :name => ut[0].titleize)
    end

    #add test users
    test_users = [
      {
      :firstname => "Administrator",
      :email => "admin@zigzeg.com",
      :username => "admin",
      :password => "t3st1ng",
      :password_confirm => "t3st1ng",
      :user_type => "administrator",
      :steps => "complete",
      :status => 1
      },
      {
      :firstname => "Test",
      :username => "normal_admin",
      :email => "normaladmin@zigzeg.com",
      :password => "t3st1ng",
      :password_confirm => "t3st1ng",
      :user_type => "normal_admin",
      :steps => "welcome",
      :status => 1
      },
      {
      :firstname => "Regular User",
      :email => "user@zigzeg.com",
      :username => "user",
      :password => "t3st1ng",
      :password_confirm => "t3st1ng",
      :user_type => "regular",
      :status => 1,
      :steps => "welcome",
      },
      {
      :firstname => "Regular User2",
      :email => "user2@zigzeg.com",
      :username => "user2",
      :password => "t3st1ng",
      :password_confirm => "t3st1ng",
      :user_type => "regular",
      :steps => "welcome",
      :status => 1
      },
      {
      :firstname => "Advertiser User",
      :email => "advert@zigzeg.com",
      :username => "advertiser",
      :password => "t3st1ng",
      :password_confirm => "t3st1ng",
      :user_type => "advertiser",
      :advert_company_name => "zigzeg advertiser",
      :advert_company_name_registered => "zigzeg",
      :advert_company_reg_number => "123456",
      :steps => 'welcome',
      :status => 1
      },
      {
      :firstname => "System User",
      :email => "system@zigzeg.com",
      :username => nil,
      :password => "t3st1ng",
      :user_type => "system",
      :password_confirm => "t3st1ng",
      :steps => "welcome",
      :status => 0
      }
    ]

    test_users.each do|user_params|
      puts 'Creating/Updating user: ' + user_params[:email]
      u = User.find_by_email(user_params[:email])
      User.create_update(user_params) if u.nil?
    end

    puts "Creating sample free payment package for advert@zigzeg.com"
    u = User.find_by_email("advert@zigzeg.com")
    Payment.free_account(u)

    GlobalSetting.create!(:option_name => "Govt. Tax", :option_value => 0, :code => "GOVTAX")


  end



  # generate complete address the column complete_address in table map_address
  task :complete_address => :environment do
    puts "Updating complete_address column in map_address table..."

    MapAddress.all.each do |add|
      section = add.section
      state = add.state
      city = add.city
      country = add.country

      complete_address = "#{add.building_name}"
      complete_address += " #{add.street}"
      complete_address += " #{section.name}" unless section.nil?
      complete_address += " #{section.postalcode}" unless section.nil?
      complete_address += " #{city.name}" unless city.nil?
      complete_address += " #{state.name}" unless state.nil?
      complete_address += " #{country.name}" unless country.nil?

      add.complete_address = complete_address
      add.save!
    end
    puts "done..."
  end

  task :assign_random_address => :environment do
    all = []
    Place.all.each do |p|
      lat = [2, 3,4,5,6].shuffle.first + (rand.round(3) * rand.round(4))
      lng = [99,100,101,102,103].shuffle.first + (rand.round(3) * rand.round(4))
      all << "#{lat} == #{lng}"
      puts "#{lat} == #{lng}"
      unless p.address.nil?
        add = p.address
        add.addressable = p
        add.country_id =1
        add.state_id = 1
        add.street = "Jalan Nangka SS2 47400 Subang Jaya Selangor Malaysia"
        add.lat = lat
        add.lng = lng
        add.map_address_id = 3
        add.save!
      else
        Address.create!(:addressable => p, :country_id => 1, :state_id => 1, :street => "Jalan Nangka SS2 47400 Subang Jaya Selangor Malaysia", :lat => lat, :lng => lng, :map_address_id => 3)      
      end
    end

    Deal.all.each do |p|
      lat = [2, 3,4,5,6].shuffle.first + (rand.round(4) * rand.round(2))
      lng = [99,100,101,102,103].shuffle.first + (rand.round(3) * rand.round(2))
      all << "#{lat} == #{lng}"
      puts "#{lat} == #{lng}"
      
      unless p.address.nil?
        add = p.address
        add.addressable = p
        add.country_id =1
        add.state_id = 1
        add.street = "Jalan Nangka SS2 47400 Subang Jaya Selangor Malaysia"
        add.lat = lat
        add.lng = lng
        add.map_address_id = 3
        add.save!
      else
        Address.create!(:addressable => p, :country_id => 1, :state_id => 1, :street => "Jalan Nangka SS2 47400 Subang Jaya Selangor Malaysia", :lat => lat, :lng => lng, :map_address_id => 3)      
      end
    end

    Event.all.each do |p|
      lat = [2, 3,4,5,6].shuffle.first + (rand.round(3) * rand.round(2))
      lng = [99,100,101,102,103].shuffle.first + (rand.round(3) * rand.round(5))
      all << "#{lat} == #{lng}"
      puts "#{lat} == #{lng}"
      unless p.address.nil?
        add = p.address
        add.addressable = p
        add.country_id =1
        add.state_id = 1
        add.street = "Jalan Nangka SS2 47400 Subang Jaya Selangor Malaysia"
        add.lat = lat
        add.lng = lng
        add.map_address_id = 3
        add.save!
      else
        Address.create!(:addressable => p, :country_id => 1, :state_id => 1, :street => "Jalan Nangka SS2 47400 Subang Jaya Selangor Malaysia", :lat => lat, :lng => lng, :map_address_id => 3)      
      end
    end
    
    puts all.length
    puts all.uniq.length

  end


  task :load_cities_countries => :environment do
    puts "Adding Countries..."
    RawCountry.all.each do |c|
     puts c.Country.to_s
     name = c.Country
     code = c.ISO3
     country = Country.find_by_code(code) || Country.new
     country.name = name
     country.code = code
     country.save!

     c.regions.each do |r|
       puts "Region: #{r.Region}"
       rname = r.Region
       rcode = r.Code
       state = State.find_by_name_and_code(rname, rcode) || State.new(:name => rname, :code => rcode, :country_id => country.id)
       state.save!

       r.raw_cities.each do |c|
         puts "City: #{c.City}"
         cname = c.City
         ccode = c.County
         clat = c.Latitude
         clong = c.Longitude
         ctzone = c.TimeZone

         city = City.find_by_name_and_code(cname, code) || City.new
         city.name = cname
         city.code = ccode
         city.lat = clat
         city.lng = clong
         city.timezone = ctzone
         city.state_id = state.id
         city.save!
       end
     end
    end

  end


  task :reset_searchables  => :environment do
    puts "Preparing searchable table for autocomplete searching..."
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE searchables")
    puts "Done emptying..."

    puts "\n\nReading Places, Events, Deals..."
    Listing.where("status=1").each do |l|

              unless l.listable.nil?
                unless l.listable.place.nil?
                  fcodes = l.listable.place.category_features
                  features = CategoryFeature.where("code IN (?)", fcodes)
                  features.each do |f|
                    new_rec = Searchable.find_by_text(f.name) || Searchable.new
                    unless new_rec.nil?
                      new_rec.text = f.name
                      new_rec.column_name = "name"
                      new_rec.searchable_id = f.id
                      new_rec.searchable_type = f.class.name
                      new_rec.save!
                    end
                  end
                end
              end



      l.attributes.keys.each do |attr|
        if ["category_name", "sub_category_name", "name", "tags", "category_features"].include?(attr.to_s)
          puts "Inserting #{l.attributes[attr]}"
          text = l.attributes[attr]

          unless text.blank?

            if attr.to_s == "tags"
              text.split(",").each do |tag|
                tag.strip!
                new_rec = Searchable.find_by_text(tag) || Searchable.new
                new_rec.text = tag
                new_rec.column_name = attr
                new_rec.searchable_id = l.id
                new_rec.searchable_type = l.class.name
                new_rec.save!
              end
            elsif attr.to_s == "sub_category_name"
              unless l.listable.nil?
                unless l.listable.place.nil?
                  unless l.listable.place.sub_category.nil?
                    sub_cat_ids = l.listable.place.sub_category.split(",")
                    Category.find(sub_cat_ids).each do |c|
                      new_rec = Searchable.find_by_text(c.name) || Searchable.new
                      unless new_rec.nil?
                        new_rec.text = c.name
                        new_rec.column_name = attr
                        new_rec.searchable_id = l.id
                        new_rec.searchable_type = l.class.name
                        new_rec.save!
                      end
                    end
                  end
                end
              end

            else
              text.strip!
              new_rec = Searchable.find_by_text(text) || Searchable.new
              unless new_rec.nil?
                new_rec.text = l.attributes[attr]
                new_rec.column_name = attr
                new_rec.searchable_id = l.id
                new_rec.searchable_type = l.class.name
                new_rec.save!
              else
                text.strip!
                new_rec = Searchable.find_by_text(text) || Searchable.new
                new_rec.text = text
                new_rec.column_name = attr
                new_rec.searchable_id = l.id
                new_rec.searchable_type = l.class.name
                new_rec.save!
              end
              puts new_rec.inspect
            end

          end
        end

      end


      unless l.listable.nil?
        unless l.listable.place.nil?
          l.listable.place.highlights.each do |h|
              new_rec = Searchable.find_by_text(h.highlight_category.name) || Searchable.new
              new_rec.text = h.highlight_category.name
              new_rec.column_name = "name"
              new_rec.searchable_id = h.highlight_category.id
              new_rec.searchable_type = h.highlight_category.class.name
              new_rec.save!
          end
        end
      end

        puts "Reading Addresses..."
        unless l.listable.map_address.nil?
          add = l.listable.map_address
          add.attributes.keys.each do |key|
            if ["country_name", "state_name","city_name", "postcode", "section_name", "street", "building_name"].include?(key.to_s)
              text = "#{add.attributes[key]}"
              text.strip!
              unless text.blank?
                new_rec = Searchable.find_by_text(text) || Searchable.new
                new_rec.text = text
                new_rec.column_name = key
                new_rec.searchable_id = add.id
                new_rec.searchable_type = add.class.name
                new_rec.save!
                puts new_rec.inspect
              end
            end
          end
        end
    end

    puts "\nDone..."
  end
end
