namespace :setup do

  task :categories => :environment do
    categs = [["Jobs","jobs"], ["Personals","personals"], ["For Sale","forsale"], ["Housing","housing"], ["Daily Deals","dailydeals"]]
    categs.each do |cat|
      puts "adding category #{cat[0]} => #{cat[1]}"
      cat = Category.find_by_code(cat[1]) || Category.new()
      cat.code = cat[1]
      cat.name = cat[0]
      cat.save
    end
  end
  
  task :states => :environment do
    states = {'AL'=>"Alabama",  
    			'AK'=>"Alaska",  
    			'AZ'=>"Arizona",  
    			'AR'=>"Arkansas",  
    			'CA'=>"California",  
    			'CO'=>"Colorado",  
    			'CT'=>"Connecticut",  
    			'DE'=>"Delaware",  
    			'DC'=>"District Of Columbia",  
    			'FL'=>"Florida",  
    			'GA'=>"Georgia",  
    			'HI'=>"Hawaii",  
    			'ID'=>"Idaho",  
    			'IL'=>"Illinois",  
    			'IN'=>"Indiana",  
    			'IA'=>"Iowa",  
    			'KS'=>"Kansas",  
    			'KY'=>"Kentucky",  
    			'LA'=>"Louisiana",  
    			'ME'=>"Maine",  
    			'MD'=>"Maryland",  
    			'MA'=>"Massachusetts",  
    			'MI'=>"Michigan",  
    			'MN'=>"Minnesota",  
    			'MS'=>"Mississippi",  
    			'MO'=>"Missouri",  
    			'MT'=>"Montana",
    			'NE'=>"Nebraska",
    			'NV'=>"Nevada",
    			'NH'=>"New Hampshire",
    			'NJ'=>"New Jersey",
    			'NM'=>"New Mexico",
    			'NY'=>"New York",
    			'NC'=>"North Carolina",
    			'ND'=>"North Dakota",
    			'OH'=>"Ohio",  
    			'OK'=>"Oklahoma",  
    			'OR'=>"Oregon",  
    			'PA'=>"Pennsylvania",  
    			'RI'=>"Rhode Island",  
    			'SC'=>"South Carolina",  
    			'SD'=>"South Dakota",
    			'TN'=>"Tennessee",  
    			'TX'=>"Texas",  
    			'UT'=>"Utah",  
    			'VT'=>"Vermont",  
    			'VA'=>"Virginia",  
    			'WA'=>"Washington",  
    			'WV'=>"West Virginia",  
    			'WI'=>"Wisconsin",  
    			'WY'=>"Wyoming"}
    states.keys.each do |k|
      puts "Create / Update state #{k} => #{states[k]}"
      st = State.find_by_code(k) || State.new
      st.code = k
      st.name = states[k]
      st.save
    end
  end

end
