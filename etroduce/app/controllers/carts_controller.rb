class CartsController < ApplicationController
  layout 'login_manage'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authenticate


  def show
    @cart = current_cart

    if @cart.line_items.empty?
      flash[:error] = "No unpaid posting"
      redirect_to opportunities_path(:p => 'f')
    end
  end
end