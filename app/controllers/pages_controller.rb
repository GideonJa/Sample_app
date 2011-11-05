class PagesController < ApplicationController
  def home
    @title = "Home"
   
    if signed_in?
       @micropost = current_user.microposts.build
       @microposts = current_user.feed.paginate(:page => params[:page], 
                                                      :per_page => 20)
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
     @title = "Help"
   end
end
