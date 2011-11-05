class MicropostsController < ApplicationController
  before_filter :validate_login
  before_filter :authorized_to_del, :only => :destroy
  
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
     mp = Micropost.find_by_id(params[:id])
     if mp.destroy
        flash[:success] = "Post #{mp.id} deleted successfully"
      else 
        flash[:error] = "Post was not deleted"
     end
     redirect_to root_path
  end

private
  def authorized_to_del
    if  Micropost.find_by_id(params[:id]).user.id != current_user.id
      redirect_to root_path
    end 
  end
end
