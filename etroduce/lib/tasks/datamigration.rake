namespace :datamigration do

  task :change_opp_status => :environment do
    puts "Set all opportunities to status=1"
    Opportunity.find(:all).each do |opp|
      puts "Updating record #{opp.id} - by #{opp.user.fullname}"
      opp.status = true
      opp.save
    end
  end

end
