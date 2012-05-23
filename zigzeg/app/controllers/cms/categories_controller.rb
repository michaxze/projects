class Cms::CategoriesController < ApplicationController
  layout 'user_cms'
  before_filter :authenticate
  respond_to :html, :json, :xml

  def index
    @categories = Category.ordered_byparent(params[:s])
  end

  def update
    @category = Category.find(params[:id])
    @category.update_attributes(params[:category])
    flash[:notice] = "Category updated."
    respond_with(@category, :location => cms_categories_path)
  end

  def create
    @category = Category.new(params[:category])
    @category.save!
    redirect_to cms_categories_path, :notice => "Category successfully created"
  end

  def new
    load_category_select
  end

  def edit
    @category = Category.find(params[:id])
    load_category_select
    respond_with(@category)
  end

  def destroy
    @cat = Category.find(params[:id])
    @cat.destroy
    flash[:notice] = "Category deleted."
    respond_with(@cat, :location => cms_categories_path)
  end

  private
    def load_category_select
      @category_select = []
      Category.where("parent_id IS NULL").collect { |c| @category_select << [c.name.titleize, c.id] }
    end

end
