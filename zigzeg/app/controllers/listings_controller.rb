class ListingsController < ApplicationController
  before_filter :compute_totals, :only => [:index, :tagsearch, :search]
  before_filter :public_top_checker
  before_filter :check_completeness

  def index
    unless params[:search].blank?
      params[:search] = params[:search].gsub("Search...", "")
    end

    catids = params[:category] || nil
    @listings = Listing.get(params[:page], params[:search],
                { :type => params[:type],
                  :categories => params[:category],
                  :per_page => Constant::PER_PAGE,
                  :bytime => (params[:time] rescue nil)
                })
    unless params[:btnSearch].nil?
      listings = Listing.search(params[:search], { :type => params[:type], :categories => catids})
      all_hash = listings.group_by(&:listing_type)
      @total_all = listings.length rescue 0
      @total_places  = all_hash["place"].length rescue 0
      @total_events = all_hash["event"].length rescue 0
      @total_deals  = all_hash["deal"].length rescue 0
    end

    @categories = []
    unless catids.nil?
      unless catids.blank?
        @categories = Category.find(catids)
      end
    end

    unless params[:type].blank?
      if @listings.length > 0
        html = "<div class=\"selecterContent\"> <ul class=\"listview imglist\" id=\"allView\"><script>filter = \"#{params[:type]}\"; </script>"
        html += render_to_string( :partial => "listing", :collection => @listings)
        html += "</ul></div>"
	render :text => html
      else
        unless params[:time].nil?
          render :text => '<div class="pad_top20 resultNone"><h6 class="bold pad_top30">There are currently no open listings.</h6> <a class="blue" href="/">Back to home</a></div>'
        else
          render :text => '<div class="pad_top20 resultNone"><h6 class="bold pad_top30">There are no listings available</h6></div>'
        end
      end
    end
  end

  def create_shout
    unless current_user.nil?
      listing = Listing.find(params[:id])
      unless listing.nil?
        shout = Shout.create!(:user_id => current_user.id, :shoutable => listing.listable, :content => params[:content])
        param = { :section => Constant::NEW_SHOUT , :action_name => Constant::ADDED }
        ListingUpdate.create_new(current_user, shout, param)
        broadcast("/account")
      end
    end
    
    redirect_to params[:ref_url]
  end

  def search
    unless params[:search].blank?
      params[:search] = params[:search].gsub("Search...", "")
    end

    @listings = Listing.get(params[:page], params[:search], { :type => params[:type], :categories => params[:category]})

    unless params[:type].blank?
      if @listings.length > 0
        html = "<div class=\"selecterContent\"> <ul class=\"listview imglist\" id=\"allView\">"
        html += render_to_string( :partial => "listing", :collection => @listings)
        html += "</ul></div>"
        render :text => html
      else
        render :text => "No results found."
      end
    end
  end

  def showmore
    @listings = Listing.get(params[:page], params[:search], { :type => params[:type], :categories => params[:category], :per_page => Constant::PER_PAGE})
    unless @listings.empty?
      unless params[:type].blank?
        if @listings.length > 0
          html = render_to_string( :partial => "listing", :collection => @listings)
          render :text => html
        else
          render :text => "No results found."
        end
      end

    else
      render :nothing => true
    end
  end

#  def tagsearch
#    @listings = Listing.get(params[:page], params[:tag])
#    render  :index
#  end

  def search_autocomplete
    return_str = ""
    results = Searchable.where("text like ?", "%#{params[:q]}%")

    results.each do |l|
      return_str += "#{l.text.downcase}|#{l.text.downcase}\n"
    end

    render :text => return_str
  end

  def show
    @place = Place.find_by_page_code(params[:name])
    unless @place.nil?
      @place.increment(:views, 1) unless @place.nil?
    end
  end

  #ask a question action
  def contactus
    if request.post?
      place = Place.find(params[:place_id])
      user = User.find_by_email(params[:email])

      msg = Message.new
      msg.contents = params[:message]
      msg.sender = user
      msg.receiver = place.user
      msg.viewer = place.user
      msg.msgtype = 'inbox'
      msg.subject = params[:subject] unless params[:subject].nil?

      if msg.save!
        msg.update_attribute(:message_thread_id, MessageThread.create_thread(user, place.user).id)
        sent = msg.clone
        sent.msgtype = 'sent'
        sent.is_viewed = true
        sent.viewer = current_user
        sent.save!

        Resque.enqueue(Contactconfirmation, msg.id, place.user.id)
      end
      render :nothing => true
    end
  end

  # when click the contact us at the footer..
  def contact_zigzeg
    if request.post?

      admin = User.find_by_email("admin@zigzeg.com")
      msg = Message.new
      msg.subject = "New Message from contact us"
      msg.contents = params[:message]
      msg.sender = current_user unless current_user.nil?
      msg.receiver = admin
      msg.viewer = admin
      msg.msgtype = 'inbox'
      msg.contact_telno = params[:contact] unless params[:contact].nil?

      if msg.save!
        msg.message_thread_id = MessageThread.create_ifnone(admin, current_user).id unless current_user.nil?
        Resque.enqueue(Contactzigzeg, msg.id)
        
        user = User.find_by_email(params[:email]) rescue nil
        unless user.nil?
          Resque.enqueue(Contactconfirmation, user.id, params[:email], params[:name])
        else
          Resque.enqueue(Contactconfirmation, nil, params[:email], params[:name])
        end
      end
      render :nothing => true
    end

  end

  def zigthis
    listing = Listing.find(params[:listing_id])

    unless listing.nil?
      unless current_user.nil?
        Favorite.create_zig(listing, current_user) if listing.listable.user_id != current_user.id
        render :nothing => true
      else
        render :text =>  "notloggedin"
      end
    else
      render :text =>  "invalid_listing"
    end
  end

  def reportthis
    rl = ReportedListing.new(:listing_id => params[:listing_id], :report_type => params[:report])
    rl.content = params[:content] unless params[:content].nil?
    rl.user_id = current_user.id unless current_user.nil?
    rl.save!
    render :nothing => true
  end

  def view_category
  end

  def branches
  end

  def services
  end

  def brands
  end

  def products
  end

  private
    def compute_totals
      all = Listing.find(:all, :conditions => ["status=1"])
      all_hash = all.group_by(&:listing_type)
      @total_all = all.length rescue 0
      @total_places  = all_hash["place"].length rescue 0
      @total_events = all_hash["event"].length rescue 0
      @total_deals  = all_hash["deal"].length rescue 0
    end

end
