class Admins::BlogsController < ApplicationController
  layout 'admin'
  before_filter :authenticate
  use_tinymce :new, :edit, :create

  def edit
    @blog = Blog.find(params[:id])
  end
  
  def delete
    blog = Blog.find(params[:id])
    blog.destroy
    redirect_to admins_blogs_path
  end
  
  def show
    raise "show"
  end
  
  def index
    @blogs = Blog.paginate( :page => params[:page],
                            :per_page   => 10,
                            :order      => 'created_at DESC'
                          )
  end

  def update
    @blog = Blog.find(params[:id])

    if @blog.update_attributes(params[:blog])
      unless params[:images].nil?
        params[:images].each do |img|
          a = Asset.new
          a.uploadable = @blog
          a.file = img
          a.save
        end
      end

      flash[:notice] = "Post updated."
      redirect_to admins_blogs_path
    else
      render :action => :edit
    end

  end


  def create
    @blog = Blog.new(params[:blog])
    if @blog.save
      unless params[:images].nil?
        params[:images].each do |img|
          a = Asset.new
          a.uploadable = @blog
          a.file = img
          a.save
        end
      end
      
      flash[:notice] = "Post created."
      redirect_to admins_blogs_path
    else
      render :action => :new
    end

  end
  
  def new
  end
end
