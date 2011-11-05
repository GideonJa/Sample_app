class MicropostsController < ApplicationController
  before_filter :validate_login
  
  def create
       @micropost = current_user.microposts.build(params[:micropost])
       if @micropost.save
          flash[:success] = "Post was created successfully"
          redirect_to current_user
        else
          render 'pages/home'
       end # if
  end
  
  def destroy
  end

end
