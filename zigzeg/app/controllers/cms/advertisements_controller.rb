class Cms::AdvertisementsController < ApplicationController
  layout 'user_cms'
  before_filter :authenticate

  def index
  end

end
