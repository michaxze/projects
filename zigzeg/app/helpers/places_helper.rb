module PlacesHelper

  def show_rates_number(listing)
    if ["event", "deal"].include?(listing.class.name.downcase)
      ret = "Be the first to rate this"
    else
      if listing.total_rates > 1
				ret = "rated by #{listing.total_rates} persons"
			elsif listing.total_rates > 0
				ret = "rated by #{listing.total_rates} person"
			else
				ret = "Be the first to rate this"
			end
    end
  end

end
