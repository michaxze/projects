class RegistrationController < ApplicationController
  layout 'registration'
  before_filter :redirect_iflogin, :except => [:validate_cname]

  def validate_cname
    type = params[:type] || "place"
    id = params[:id] || nil
    valid = Listings.is_name_unique(params[:name], type, id)
    ret = valid ? "true" : "false"
    render :text => ret
  end

  def validate_email
    ret = false
    u = User.find_by_email(params[:email]) rescue nil
    ret = "true" if u
    ret = "false" if u.nil?
    render :text => ret
  end

  def business_reg
    @page_title = "Payment & Registration for #{params[:package].titleize} account"

    if params[:package] == "basic"
      @package = Package.find_by_package_code("basic_yearly")
    else
      @package = Package.find_by_package_code("premium_yearly")
    end
    @packages = Package.all.group_by(&:package_code)
  end

  def update_package_information
    package = Package.find_by_package_code(params[:package_code])
    render :partial => "package_information", :layout => false, :locals => { :package => package }
  end

  def update_pricing_information
    package = Package.find_by_package_code(params[:package_code])
    render :partial => "package_pricing", :layout => false, :locals => { :package => package }
  end

  def signup
    @page_title = "Register a ZIGZEG account"
    if request.post?
      begin
        if !User.is_unique?(params[:user][:email], 'email')
          render :text => "Email address already in use.<br />Please use a different email."
        elsif !params[:user][:username].nil? && !User.is_unique?(params[:user][:username], 'username')
	        render :text => "Username already taken."
        elsif Listings.is_name_unique(params[:user][:advert_company_name], 'place')
          render :text =>  "Company name already exists." and return
        else
          if params[:user][:password] != params[:user][:password_conf]
            raise "Passwords do not match."
          end

          @user = User.create_update(params[:user])

          if !params[:packageType].blank? && params[:packageType] != "free"
            package = Package.find_by_package_code(params[:packageType])
            payment = Payment.new
            payment.user_id = @user.id
            payment.package_id = package.id
            payment.payment_method = params[:payment_method]
            payment.contract_start = Time.now.to_date
            payment.contract_end = case params[:packageType]
              when "basic_monthly"
                (Time.now + 1.months).to_date
              when "basic_yearly"
                (Time.now + 12.months).to_date
              when "premium_monthly"
                (Time.now + 1.months).to_date
              when "premium_yearly"
                (Time.now + 12.month).to_date
              end

            payment.amount = params[:total_amount] unless params[:total_amount].nil?
            payment.save!

          else
            Payment.free_account(@user)
          end
          @user.update_attribute(:find_out, params[:find_out]) unless params[:find_out].nil?
          @user.update_attribute(:find_out, params[:find_out_other]) unless params[:find_out_other].nil?

          confirmation = Confirmation.create_confirmation(@user, params[:user])
          activation_link = confirm_url(:token => confirmation.token)

          unless params[:user][:user_type].nil?
            Mailer.registration_confirmation_payment(confirmation.confirmable, activation_link, payment).deliver
          else
            Mailer.registration_confirmation(confirmation.confirmable, activation_link).deliver
          end

          if request.xhr?
            render :text => "success"
          else
            redirect_to signup_success_path(:signup => params[:signup], :package => params[:package], :email => params[:user][:email])
          end

        end
      rescue Exception => e
        render :text => e.message.to_s.gsub("Validation failed:","").split(",").join("\n")
      end
    end
  end

  def signup_success
    @page_title = "Registration successful!"
    @user = User.find_by_email(params[:email])
  end


end
