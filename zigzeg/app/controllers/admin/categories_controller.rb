class Admin::CategoriesController < ApplicationController
  layout "admin"
  before_filter :authenticate
  before_filter :admin_authenticate
  before_filter :admin_updates_checker

  def index
    @categories = Category.get_parents(params[:page])
  end

  def show
  end

  def create
    if request.post?
      begin
        @cat = Category.create_update(params[:name])

        unless params[:category].nil?
          params[:category].each do |ncat|
            Category.create_update(ncat, @cat)
          end
        end

        redirect_to admin_categories_path
      rescue  Exception => e
        flash[:error] = e.message.to_s
        redirect_to new_admin_category_path
      end
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    cat = Category.find(params[:id])

#    params[:subcategories_ids].each_with_index do |cat_id, index|
#      cat = Category.find(cat_id)
#      cat.update_attribute(:name, params[:subcategories][index] ) unless cat.nil?
#    end
#
    unless params[:category].nil?
      params[:category].first.split(",").each do |ncat|
        Category.create_update(ncat, cat)
      end
    end

    redirect_to admin_categories_path
  end

  def destroy
    cat = Category.find(params[:id])
    cat.destroy unless cat.nil?
    render :nothing => true
  end

  def remove_categories
    js_string = ""
    unless params[:ids].blank?
      Category.where("id IN (?)", params[:ids].split(",")).destroy_all
      params[:ids].split(",").each do |id|
        js_string += "$('.category_row_#{id}').fadeOut(function(){ $(this).remove()});"
      end
    end
    render :js => js_string
  end

end
