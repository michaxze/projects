class Cms::RatesController < ApplicationController
  layout 'user_cms'
  before_filter :authenticate
  respond_to :html, :xml, :json

  def index
    @rates = Rate.all
  end

  def update
    @rate = Rate.find(params[:id])
    @rate.update_attributes(params[:rate])

    flash[:notice] = "Successfully updated."
    respond_with(@rate, :location => cms_rates_path)
  end

  def edit
    @rate = Rate.find(params[:id])
  end

  def destroy
    @rate = Rate.find(params[:id])
    respond_with(@rate, :location => cms_rates_path)
  end

end
