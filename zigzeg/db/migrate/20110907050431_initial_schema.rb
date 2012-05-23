class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :firstname, :null => true
      t.string :lastname, :null => true
      t.string :middlename, :null => true
      t.string :user_type, :default => "regular"
      t.integer :status, :default => 0
      t.string :gender, :null => true
      t.date   :dob, :null => true
      t.string :secondary_email, :null => true
      t.string :race, :null => true
      t.string :religion, :null => true
      t.string :nationality, :null => true

      t.string :company_name, :null => true
      t.string :work_from, :null => true
      t.string :work_to, :null => true
      t.string :designation, :null => true
      t.string :description, :null => true
      t.string :college, :null => true
      t.string :profession, :null => true
      t.string :year_from, :null => true
      t.string :year_to, :null => true
      t.string :grade, :null => true
      t.integer :city_id, :null => true
      t.integer :section_id, :null => true

      t.string :telno
      t.string :mobileno
      t.string :direct_line_no
      t.string :faxno
      t.string :website_url
      t.string :facebook
      t.string :twitter


      t.integer :address_id, :null => true

      t.string :avatar_file_name
      t.string :avatar_content_type
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at

      t.string :advert_company_name, :null => true
      t.string :advert_company_name_registered, :null => true
      t.string :advert_company_reg_number, :null => true

      t.string :settings, :null => true
      t.string :package_typ, :null => true
      t.string :steps, :default => "welcome"
      
      t.string :provider, :null => true
      t.string :uid, :null => true
      t.string :image_facebook, :null => true
      t.text   :facebook_information, :null => true
      
      t.datetime :last_login, :null => true
      t.timestamps
    end
    add_index :users, :username
    add_index :users, [:username, :password]
    add_index :users, [:username, :password, :status]

    create_table :user_types, :force => true do |t|
      t.string :code
      t.string :name
    end
    add_index :user_types, :code

    create_table :logins, :force => true do |t|
      t.string :username
      t.string :ipaddress
      t.date :created_at
    end
    add_index :logins, :username

    create_table :companies, :force => true do |t|
      t.string :name
      t.string :code
    end

    create_table :highlights do |t|
      t.integer  :highlightable_id
      t.string   :highlightable_type
      t.integer  :highlight_category_id
      t.timestamps
    end

    create_table :highlight_categories do |t|
      t.string :name
      t.string :code
    end

    create_table :places, :force => true do |t|
      t.integer  :company_id, :null => true
      t.integer  :user_id
      t.integer  :category_id
      t.string   :name
      t.text     :description
      t.string   :telephone_numbers, :null => true
      t.string   :fax_numbers, :null => true
      t.string   :mobile_numbers, :null => true
      t.string   :website_url, :null => true
      t.string   :email, :null => true
      t.string   :tags, :null => true
      t.boolean  :status, :default => 0
      t.string   :page_code, :null => true
      t.integer  :package, :default => 0
      t.integer  :views, :default => 0
      t.text     :extra_info, :null => true
      t.string   :facebook, :null => true
      t.string   :twitter, :null => true
      t.timestamps
    end
    add_index :places, :name
    add_index :places, :page_code
    add_index :places, :user_id
    add_index :places, [:status, :created_at]
    add_index :places, :status
    add_index :places, [:id, :page_code]

    create_table :events, :force => true do |t|
      t.integer :category_id
      t.integer :place_id
      t.string  :name
      t.text    :description
      t.text    :pricing_information
      t.integer :asset_id
      t.integer :views, :default => 0
      t.string  :tags, :null => true
      t.text    :extra_info, :null => true
      t.string  :page_code
      t.date    :schedule, :null => true
      t.string  :telno, :null => true
      t.string  :faxno, :null => true
      t.string  :mobileno, :null => true
      t.string  :email, :null => true
      t.string  :website, :null => true
      t.integer :organizer_id, :null => true
      t.integer :user_id
      t.string  :status
      t.date    :start_date, :null => true
      t.date    :end_date, :null => true
      t.string  :start_time, :null => true
      t.string  :end_time, :null => true
      t.string  :event_type, :default => 'free'
      t.decimal :from_price, :precision => 8, :scale => 2
      t.decimal :to_price, :precision => 8, :scale => 2
      t.string  :facebook, :null => true
      t.string  :twitter, :null => true
      t.timestamps
    end
    add_index :events, :place_id
    add_index :events, :category_id
    add_index :events, [:id, :page_code]

    create_table :event_dates do |t|
      t.integer  :event_id
      t.date     :date
      t.string   :start_time, :null => true
      t.string   :end_time, :null => true
      t.timestamps
    end

    create_table :organizers do |t|
      t.integer :place_id
      t.string  :name
      t.text    :description
      t.timestamps
    end

    create_table :prices, :force => true do |t|
      t.integer :priceable_id
      t.string  :priceable_type
      t.string  :label, :null => true
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :user_id

      t.timestamps
    end

    create_table :deals, :force => true do |t|
      t.integer :category_id
      t.integer :place_id
      t.string  :name
      t.text    :description
      t.integer :asset_id
      t.integer :views, :default => 0
      t.string  :tags, :null => true
      t.text    :extra_info, :null => true
      t.string  :page_code
      t.date    :start
      t.date    :end
      t.boolean :ongoing, :default => false
      t.string  :locations
      t.string  :telno,:null => true 
      t.string  :faxno, :null => true
      t.string  :mobileno, :null => true
      t.string  :email, :null => true
      t.string  :website, :null => true
      t.integer :organizer_id, :null => true
      t.integer :user_id
      t.string  :status
      t.string  :facebook, :null => true
      t.string  :twitter, :null => true
      t.timestamps
    end
    add_index :deals, :place_id
    add_index :deals, :category_id
    add_index :deals, [:id, :page_code]

    create_table :products, :force => true do |t|
      t.integer :category_id
      t.integer :place_id
      t.string  :name
      t.text    :description
      t.integer :asset_id
      t.integer :views, :default => 0
      t.string  :tags, :null => true
      t.text    :extra_info, :null => true
      t.timestamps
    end
    add_index :products, :place_id

    create_table :services, :force => true do |t|
      t.integer :category_id
      t.integer :place_id
      t.string  :name
      t.text    :description
      t.integer :asset_id
      t.integer :views, :default => 0
      t.string  :tags, :null => true
      t.text    :extra_info, :null => true
      t.timestamps
    end
    add_index :services, :place_id

    create_table :brands, :force => true do |t|
      t.integer :category_id
      t.string  :name
      t.text    :description
      t.integer :asset_id
      t.integer :views, :default => 0
      t.integer :place_id
      t.string  :tags, :null => true
      t.text    :extra_info, :null => true
    end
    add_index :brands, :place_id

    create_table :ratings, :force => true do |t|
      t.integer :rateable_id
      t.string  :rateable_type
      t.integer :user_id
      t.integer :value
      t.timestamps
    end
    add_index :ratings, :user_id
    add_index :ratings, [:rateable_id, :rateable_type, :user_id]

    create_table :listing_types, :force => true do |t|
      t.string :code
      t.string :name
    end
    add_index :listing_types, :code

    create_table :listings, :force => true do |t|
      t.integer :listable_id
      t.string  :listable_type
      t.string  :listing_type
      t.integer :category_id
      t.boolean :status, :default => false
      t.string  :name, :null => true
      t.string  :description, :null => true
      t.string  :tags, :null => true
      t.string  :website_url, :null => true
      t.text    :event_info, :null => true
      t.string  :package, :null => true
      t.integer :total_rates, :default => 0
      t.integer :views, :default => 0
      t.integer :user_id
      t.timestamps
    end

    create_table :addresses, :force => true do |t|
      t.integer :addressable_id
      t.string  :addressable_type
      t.integer :country_id, :null => true
      t.integer :state_id, :null => true

      t.string  :city_name, :null => true
      t.string  :section_name, :null => true
      t.string  :postcode, :null => true
      t.string  :street, :null => true
      t.string  :address_number, :null => true
      t.string  :building_name, :null => true
      t.string  :address_roadname, :null => true
      t.string  :floor_number, :null => true
      t.string  :address_lot_number, :null => true
      t.string :lat, :null => true
      t.string :lng, :null => true
      t.integer :map_address_id, :null => true
    end
    add_index :addresses, :state_id

    create_table :states, :force => true do |t|
      t.string :name
      t.string :code
    end
    add_index :states, :id
    add_index :states, :code

    create_table :countries, :force => true do |t|
      t.string :name
      t.string :code
    end
    add_index :countries, :code

    create_table :cities, :force => true do |t|
      t.integer  :state_id
      t.string   :name
      t.string   :code
    end
    add_index :cities, :code

    create_table :sections, :force => true do |t|
      t.integer  :city_id
      t.string   :name
      t.integer  :postalcode
    end
    add_index :sections, :name

    create_table :confirmations, :force => true do |t|
      t.string   :confirmable_type
      t.integer  :confirmable_id
      t.string   :token
      t.string   :username
      t.boolean  :used
      t.date     :expire_at
    end
    add_index :confirmations, :token

    create_table :assets, :force => true do |t|
      t.integer    :authorable_id
      t.string     :authorable_type
      t.integer    :uploadable_id
      t.string     :uploadable_type

      t.string     :image_file_name
      t.string     :image_content_type
      t.integer    :image_file_size
      t.datetime   :image_updated_at
      t.timestamps 
    end
    add_index :assets, [:authorable_id, :authorable_type]
    add_index :assets, [:uploadable_id, :uploadable_type]

    create_table :categories, :force => true do |t|
      t.string  :code, :null => false
      t.string  :name, :null => true
      t.integer :parent_id, :null => true
    end
    add_index :categories, :code
    add_index :categories, :parent_id

    create_table :marked_viewed, :force => true do |t|
      t.integer :user_id
      t.integer :viewable_id
      t.string  :viewable_type
      t.datetime :listing_created_at
      t.timestamps
    end
    add_index :marked_viewed, [:user_id, :viewable_id, :viewable_type]

    create_table :favorites, :force => true do |t|
      t.integer :user_id
      t.integer :likeable_id
      t.string  :likeable_type
      t.timestamps
    end
    add_index :favorites, [:user_id, :created_at]
    add_index :favorites, :user_id

    create_table :histories, :force => true do |t|
      t.integer :user_id
      t.integer :listing_id
      t.integer :listing_type
      t.date    :created_at
      t.datetime :updated_at
    end
    add_index :histories, [:user_id, :listing_id, :created_at]
    add_index :histories, [:user_id, :created_at]

    create_table :message_threads, :force => true do |t|
      t.integer  :sender_id
      t.string   :sender_type
      t.integer  :receiver_id
      t.string   :receiver_type
      t.timestamps
    end
    add_index :message_threads, :sender_id
    add_index :message_threads, :receiver_id

    create_table :messages, :force => true  do |t|
      t.integer :sender_id
      t.string  :sender_type
      t.integer :receiver_id
      t.string  :receiver_type
      t.text    :contents
      t.string  :subject, :null => true
      t.integer :viewer_id
      t.string  :viewer_type
      t.integer :message_thread_id
      t.string  :msgtype, :default => 'inbox'
      t.boolean :is_viewed, :default => 0
      t.integer :email_template_id, :null => true
      t.string  :contact_email, :null => true
      t.string  :contact_name, :null => true
      t.string  :contact_telno, :null => true
      t.integer :parent_id, :null => true
      t.timestamps
    end
    add_index :messages, :sender_id
    add_index :messages, :receiver_id
    add_index :messages, [:sender_id, :message_thread_id]
    add_index :messages, [:receiver_id, :message_thread_id]


    create_table :readables, :force => true do |t|
      t.integer :reader_id
      t.string  :reader_type
      t.integer :readable_id
      t.string  :readable_type
      t.timestamps
    end
    add_index :readables, [:reader_id, :reader_type]
    add_index :readables, [:readable_id, :readable_type]

    create_table :rates, :force => true do |t|
      t.string :name
      t.decimal :per_day, :precision => 8, :scale => 2
      t.decimal :per_month, :precision => 8, :scale => 2
      t.decimal :per_year, :precision => 8, :scale => 2
      t.decimal :monthly_subscription_rate, :precision => 8, :scale => 2
      t.decimal :govt_tax, :precision => 8, :scale => 2
      #package feature
      t.decimal :freebies_value, :precision => 8, :scale => 2
      t.integer :deals_credits
      t.integer :deal_discounts
      t.boolean :customer_service, :default => false
      t.boolean :logo_display_onmap, :default => false
      t.string :exposure, :null => true
      t.integer :image_limit, :default => 1
      t.integer :products_limit, :default => 0
      t.integer :services_limit, :default => 0
      t.integer :brands_limit, :default => 0
      t.integer :jobs_limit, :default => 0
      t.timestamps
    end

    create_table :logs, :force => true do |t|
      t.string :location
      t.text   :content
      t.integer :user_id, :null => true
      t.string :url, :null => true
      t.text   :params, :null => true
      t.text   :user_agent, :null => true
      t.string :ip, :null => true
      t.timestamps
    end

    create_table :reported_listings do |t|
      t.integer :listing_id
      t.string  :report_type
      t.text    :content
      t.integer :user_id
      t.timestamps
    end

    create_table :pictures do |t|
      t.integer  :pictureable_id
      t.string   :pictureable_type
      t.string   :name, :null => true
      t.string   :description, :null => true
      t.string   :picture_type, :null => true # service, product, brand, misc
      t.integer  :user_id
      t.string   :image_file_name
      t.string   :image_content_type
      t.integer  :image_file_size
      t.datetime :image_updated_at
      t.timestamps
    end

    create_table :listing_updates do |t|
      t.integer :updateable_id
      t.string  :updateable_type
      t.string  :description
      t.integer :user_id
      t.integer :place_id
      t.string :section
      t.timestamps
    end

    create_table :alerts do |t|
      t.string  :alert_type
      t.string  :title, :null => true
      t.text    :description
      t.integer :sender_id
      t.string  :sender_type
      t.string  :status, :default => "pending", :null => false
      t.integer :updated_by, :null => true
      t.timestamps
    end

    create_table :temp_photos do |t|
      t.integer :user_id
      t.string  :section_type #primary photo; gallery
      t.string  :title, :null => true
      t.string  :description, :null => true
      t.string  :photo_type, :null => true   #product, services, brand, misc
      t.timestamps
    end

    create_table :payments do |t|
      t.integer :user_id
      t.string  :package_id
      t.string  :payment_method
      t.string  :invoice_no
      t.decimal :amount, :precision => 8, :scale => 2
      t.string  :status
      t.date    :contract_start, :null => true
      t.date    :contract_end, :null => true
      t.timestamps
    end
    add_index :payments, :user_id

    create_table :packages do |t|
      t.string  :package_name
      t.decimal :price, :precision => 8, :scale => 2
      t.string :payment_frequency, :null => true
      t.integer :contract_length, :default => 12 #12 months
      t.integer :allowed_announcements, :default => 0
      t.integer :allowed_images, :default => 0
      t.integer :allowed_events, :default => 0
      t.integer :allowed_deals, :default => 0
      t.boolean :full_data_service, :default => false
      t.string  :package_code, :default => "basic_monthly", :null => true
      t.integer :ranking
      t.integer :about_char_limit, :default => 250
      t.boolean :about_no_limit, :default => false
      t.timestamps
    end

    create_table :notifications do |t|
      t.integer :user_id
      t.string  :notification_type, :null => true
      t.text    :contents
      t.timestamps
    end

    create_table :address_extensions do |t|
      t.integer :addressable_id
      t.string  :addressable_type
      t.string  :number, :null => true
      t.string  :building_name, :null => true
      t.string  :floor_number, :null => true
      t.string  :lot_number, :null => true
      t.string  :floor_number, :null => true
      t.timestamps
    end

    create_table :map_addresses do |t|
      t.integer :country_id
      t.integer :state_id, :null => true
      t.integer :city_id, :null => true
      t.integer :section_id, :null => true
      t.string  :street, :null => true
      t.string  :number, :null => true
      t.string  :building_name, :null => true
      t.string  :floor_number, :null => true
      t.string  :lot_number, :null => true
      t.string  :complete_address, :null => true
      t.string  :lat, :null => true
      t.string  :lng, :null => true
      t.timestamps
    end
    
    create_table :global_settings do |t|
      t.string  :option_name, :null => false
      t.string  :code, :null => false
      t.string  :option_value, :null => false
    end

    create_table :suspended_accounts do |t|
      t.integer  :user_id, :null => false
      t.string   :reason_code, :null => false
      t.integer  :created_by, :null => true
      t.timestamps
    end
    
    create_table :discounts do |t|
      t.integer :user_id
      t.string  :name
      t.string  :discount_condition
      t.string  :discount_for
      t.string  :discount_for2
      t.string  :discount_criteria
      t.decimal :amount, :precision => 8, :scale => 2
      t.integer :duration, :null => true
      t.string  :discount_code, :null => true
      t.date    :start_date
      t.date    :end_date
      t.string  :status, :default => "pending"
      t.timestamps
    end

  end

  def self.down
  end
end
