class MicropostsController < ApplicationController
  before_filter :validate_login
  
  def create
       @micropost = current_user.microposts.build(params[:micropost])
       if @micropost.save
          flash[:success] = "Post was created successfully"
          redirect_to root_path
        else
           # @micropost =@new_micropost
           @microposts = current_user.microposts.paginate(:page => params[:page], 
                                                          :per_page => 20)
          render 'pages/home'
       end # if
  end
  
  def destroy
  end

end
