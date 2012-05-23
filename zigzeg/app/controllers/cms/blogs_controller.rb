class Cms::BlogsController < ApplicationController
  layout 'user_cms'
  before_filter :authenticate

  def index
  end

end
