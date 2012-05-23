class PagesController < ApplicationController
  layout 'pages'
  before_filter :public_top_checker
  def terms
    @page_title = "Terms"
		@page_key = ""
		@page_desc = ""
  end
  def careers
    @page_title = "Join us for exciting careers"
		@page_key = "ZIGZEG, City Information System, Career, Jobs, Placements, Vacancies, Internships"
		@page_desc = "ZIGZEG build products that changes the way people explore & interact with their city. Join us in our bid to bring the city 'literally' to the fingertips of urbanites living in modern cities of our world"
  end

  def help
    @page_title = "Help Central"
		@page_key = "ZIGZEG, City Information System, Help Central, FAQ, End-user Service Agreement, Privacy Policy, Terms & Conditions"
		@page_desc = "How can we help you? Would like to know what services and features ZIGZEG offers or how to use them? You have come to the right place. Get all your questions answered via our Help Central"
  end
	def help_biz
    @page_title = "Help Central"
		@page_key = "ZIGZEG, City Information System, Help Central, FAQ, End-user Service Agreement, Privacy Policy, Terms & Conditions"
		@page_desc = "How can we help you? Would like to know what services and features ZIGZEG offers or how to use them? You have come to the right place. Get all your questions answered via our Help Central"
  	@biz_page = "true";
	end
	def about
    @page_title = "About us"
		@page_key = "ZIGZEG, City Information System, Social, Directory, Places & Landmarks,  Offers & Deals, Events & Happenings, Discounts & Shopping, Businesses, What to do, Where to go, What to buy, Map & Locations"
		@page_desc = "ABOUT US: ZIGZEG is a city information system that combines an interactive map & a growing-by-day city information network to give people insight into the changes & happenings occurring to the cities they live in"
  end
	def notfound
    @page_title = "Page no longer available"
		@page_key = ""
		@page_desc = ""
		 render :layout => false
  end
  def errors
    @page_title = "Error"
		@page_key = "ZIGZEG, City Information System, Social, Directory, Places & Landmarks,  Offers & Deals, Events & Happenings, Discounts & Shopping, Businesses, What to do, Where to go, What to buy, Map & Locations"
		@page_desc = "ABOUT US: ZIGZEG is a city information system that combines an interactive map & a growing-by-day city information network to give people insight into the changes & happenings occurring to the cities they live in"
  end
  def contacts
    @page_title = "Contact us"
		@page_key = "ZIGZEG, City Information System, Contact us, Get in touch, ask a question, complaints, suggestions, feature request"
		@page_desc = "Get in touch with ZIGZEG: Have questions? Complaints? Suggestions? Feature request? Or would like to send us some love? Just drop us a message! We would love to hear from you."
	  if request.post?
	    Mailer.contact_admin(params[:contact]).deliver
	    flash[:notice] = "Your message has been submitted successfully."
	    redirect_to contacts_path
    end
  end
	def contactus
		@biz_page = "true";
    @page_title = "Contact us"
		@page_key = "ZIGZEG, City Information System, Contact us, Get in touch, ask a question, complaints, suggestions, feature request"
		@page_desc = "Get in touch with ZIGZEG: Have questions? Complaints? Suggestions? Feature request? Or would like to send us some love? Just drop us a message! We would love to hear from you."
	  if request.post?
	    Mailer.contact_admin(params[:contact]).deliver
	    flash[:notice] = "Your message has been submitted successfully."
	    redirect_to contactus_path
    end
  end
end
