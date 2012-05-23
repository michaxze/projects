class Cms::MapsController < ApplicationController
  layout 'user_cms'
  before_filter :authenticate

  def index
  end

end
