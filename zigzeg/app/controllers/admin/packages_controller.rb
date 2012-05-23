class Admin::PackagesController < ApplicationController
  layout "admin"
  before_filter :authenticate

  def index
    @packages = Package.all
    @discounts = Discount.order("created_at DESC")
  end
  
  def edit
    @package = Package.find(params[:id])
  end

  def show
  end
  
  def update
    @package = Package.find(params[:id])
    @package.update_attributes(params[:package])
    @package.save!

    redirect_to edit_admin_package_path(@package)
  end
  
  def create_discount
    discount = Discount.new(params[:discount])
    discount.save!
    redirect_to admin_packages_path
  end

end
