module Constant

  #UTILITIES
  MAX_FILESIZE = 4194304

  #USER TYPES
  REGULAR = "regular"
  ADVERTISER = "advertiser"
  BOTH = "both"
  ADMINISTRATOR = "administrator"

  #MAP
  MAP_INITIAL_NUMBER = 150
  MAP_MORE_NUMBER = 15

  #INDEX LISTINGS
  PER_PAGE = 15

  #MESSAGES LISTINGS
  MESSAGE_PER_PAGE = 15


  #SECTIONS
  COMPANY_NAME = "company name"
  OPERATING_HOURS = "operating hours"
  NEW_FEATURES = "new features"
  ANEW = "a new"
  ADDRESS = "address"
  NEW_IMAGES = "new images"
  NEW_OFFER = "new offer"
  NEW_EVENT = "new event"
  AN_EVENT = "an event"
  AN_OFFER = "an offer"
  NEW_SHOUT = "new shout"
  OFFER = "offer"
  EVENT = "event"
  #ACTIONS
  STARTING = "starting"
  EXPIRING = "expiring"
  UPDATED = "updated"
  CHANGED = "changed"
  ADDED = "added"
  IMAGES = "images"

  # DATA TABLES FILTERING - applies in admin cms
  FREE_ACCOUNTS      = 0
  SUSPENDED_ACCOUNTS = 2
  BASIC_ACCOUNTS     = 5
  PREMIUM_ACCOUNTS   = 6
  OVERDUE_ACCOUNTS   = 7
  NEW_ACCOUNTS       = 9

  PUBLISHED = "published"
  COMPLETE = "complete"
  DELETED = "deleted"
  EXPIRED = "expired"

  CONFIRMATION_EXPIRY = Time.now + 2.days
  USER_TYPES = [["Administrator", "administrator"], ["Regular User", "regular"], ["Businesess", "advertiser"], ["Normal Administrator", "normal_admin"]].freeze
  ADMIN_USER_TYPES = [["Master Administrator", "administrator"], ["Normal Administrator", "normal"], ["Sales Personnel", "sales"]].freeze

  NOTIFICATION_OPTIONS = [
    ["Yes, send me a notification for every update", "everytime"],
    ["Yes, send me a single daily notification for all updates", "perday"],
    ["No", "no"] ]

  NOTIFICATION_OPTIONS1 = [
   ["Yes, send me a notification for every message", "everytime"],
    ["Yes, send me a single daily notification for all messages", "perday"],
    ["No", "no"] ]

  NOTIFICATION_OPTIONS2 = [
    ["Yes", "everytime"],
    ["No", "no"] ]

  YESNO_OPTION = [
    ["Yes", "yes"],
    ["No", "no"] ]

  SETTINGS = [
    "new_message_notification",
    "new_event_notification",
    "new_deal_notification"
  ].freeze

  LISTING_TYPES = { "deal"  => "d", "event" => "e", "place" => "p" }
  GENDERS = [["Male","male"], ["Female", "female"]]
  NATIONALITIES = [
    "Afghan",
    "Albanian",
    "Algerian",
    "American",
    "Andorran",
    "Angolan",
    "Antiguans",
    "Argentinean",
    "Armenian",
    "Australian",
    "Austrian",
    "Azerbaijani",
    "Bahamian",
    "Bahraini",
    "Bangladeshi",
    "Barbadian",
    "Barbudans",
    "Batswana",
    "Belarusian",
    "Belgian",
    "Belizean",
    "Beninese",
    "Bhutanese",
    "Bolivian",
    "Bosnian",
    "Brazilian",
    "British",
    "Bruneian",
    "Bulgarian",
    "Burkinabe",
    "Burmese",
    "Burundian",
    "Cambodian",
    "Cameroonian",
    "Canadian",
    "Cape Verdean",
    "Central African",
    "Chadian",
    "Chilean",
    "Chinese",
    "Colombian",
    "Comoran",
    "Congolese",
    "Costa Rican",
    "Croatian",
    "Cuban",
    "Cypriot",
    "Czech",
    "Danish",
    "Djibouti",
    "Dominican",
    "Dutch",
    "East Timorese",
    "Ecuadorean",
    "Egyptian",
    "Emirian",
    "Equatorial Guinean",
    "Eritrean",
    "Estonian",
    "Ethiopian",
    "Fijian",
    "Filipino",
    "Finnish",
    "French",
    "Gabonese",
    "Gambian",
    "Georgian",
    "German",
    "Ghanaian",
    "Greek",
    "Grenadian",
    "Guatemalan",
    "Guinea-Bissauan",
    "Guinean",
    "Guyanese",
    "Haitian",
    "Herzegovinian",
    "Honduran",
    "Hungarian",
    "I-Kiribati",
    "Icelander",
    "Indian",
    "Indonesian",
    "Iranian",
    "Iraqi",
    "Irish",
    "Israeli",
    "Italian",
    "Ivorian",
    "Jamaican",
    "Japanese",
    "Jordanian",
    "Kazakhstani",
    "Kenyan",
    "Kittian and Nevisian",
    "Kuwaiti",
    "Kyrgyz",
    "Laotian",
    "Latvian",
    "Lebanese",
    "Liberian",
    "Libyan",
    "Liechtensteiner",
    "Lithuanian",
    "Luxembourger",
    "Macedonian",
    "Malagasy",
    "Malawian",
    "Malaysian",
    "Maldivan",
    "Malian",
    "Maltese",
    "Marshallese",
    "Mauritanian",
    "Mauritian",
    "Mexican",
    "Micronesian",
    "Moldovan",
    "Monacan",
    "Mongolian",
    "Moroccan",
    "Mosotho",
    "Motswana",
    "Mozambican",
    "Namibian",
    "Nauruan",
    "Nepalese",
    "New Zealander",
    "Nicaraguan",
    "Nigerian",
    "Nigerien",
    "North Korean",
    "Northern Irish",
    "Norwegian",
    "Omani",
    "Pakistani",
    "Palauan",
    "Panamanian",
    "Papua New Guinean",
    "Paraguayan",
    "Peruvian",
    "Polish",
    "Portuguese",
    "Qatari",
    "Romanian",
    "Russian",
    "Rwandan",
    "Saint Lucian",
    "Salvadoran",
    "Samoan",
    "San Marinese",
    "Sao Tomean",
    "Saudi",
    "Scottish",
    "Senegalese",
    "Serbian",
    "Seychellois",
    "Sierra Leonean",
    "Singaporean",
    "Slovakian",
    "Slovenian",
    "Solomon Islander",
    "Somali",
    "South African",
    "South Korean",
    "Spanish",
    "Sri Lankan",
    "Sudanese",
    "Surinamer",
    "Swazi",
    "Swedish",
    "Swiss",
    "Syrian",
    "Taiwanese",
    "Tajik",
    "Tanzanian",
    "Thai",
    "Togolese",
    "Tongan",
    "Trinidadian or Tobagonian",
    "Tunisian",
    "Turkish",
    "Tuvaluan",
    "Ugandan",
    "Ukrainian",
    "Uruguayan",
    "Uzbekistani",
    "Venezuelan",
    "Vietnamese",
    "Welsh",
    "Yemenite",
    "Zambian",
    "Zimbabwean"
  ].freeze

  RESERVED_USERNAMES = [
    # controllers
    "users",
    "application",
    "invitations",
    "opportunities",
    "contacts",
    "contact_lists",
    "contacts_list",
    "etros",
    "messages",
    "mthreads",
    "pages",
    "profiles",
    "tags",
    "user_networks",
    "user_numbers",
    "work_infos",
    "sessions",
    "admin",
    "bizsp",
    "getting_started",
    "notifications",
    "classifieds",
    "admins",
    "accounts",
    "myopportunities",
    "public",


    # special routes
    "profile",
    "login",
    "logout",
    "forgot_password",
    "password_reset",
    "signup",
    "aboutus",
    "contactus",
    "activate",
    "confirm",
    "settings",
    "account",
    "sign_in",
    "sign_out",
    "confirm",
    "tw_callback",
    "dashboard",
    "my_contacts",
    "search",
    "alpha",
    "beta",
    "sign",
    "out",
    "terms",
    "privacy",
    "facebook",
    "linkedin",
    "twitter",
    "link",
    "start",
    "jobs",

    #categories
    "personals",
    "deals",
    "dailydeals",
    "housing",
    "forsale",
    "sale",
    "cars",
    "services",

    # reserved usernames
    "admin",
    "superuser",
    "root"
   ].collect(&:freeze)

   def self.states
     states = []
     State.find(:all, :order => "name ASC").each { |s| states << [ s.name, s.id ] }
     states
   end
end
