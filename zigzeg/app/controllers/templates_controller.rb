class TemplatesController < ApplicationController
  layout nil

  def view
    @template = EmailTemplate.find(params[:id])
  end



end
