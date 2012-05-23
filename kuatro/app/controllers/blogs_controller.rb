class BlogsController < ApplicationController
  
  def index
    @blogs = Blog.paginate( :page => params[:page],
                            :per_page   => 10,
                            :order      => 'created_at DESC',
                            :conditions => "status='publish'"
                          )

  end
  
  def viewpost
    @blog = Blog.find_by_page_code(params[:code])
    all = Blog.where("status='publish'").order("created_at DESC")
    ids = all.map(&:id)
    @prev = nil
    @next =  nil
    indx = ids.index(@blog.id)

    unless ids[indx+1].nil?
      @prev = Blog.find(ids[indx+1])  
    end

    if (indx-1) >= 0 
      @next = Blog.find(ids[indx-1])  
    end
    
    redirect_to blogs_path if @blog.nil?
  end


end
