class UsersController < ApplicationController
  before_filter :validate_login,  :only => [:index, :edit, :update, :destroy]
  before_filter :validate_logged_out, :only => [:new, :create]
  before_filter :validate_login_match_user,  :only => [:edit, :update]
  before_filter :validate_admin,  :only => :destroy
   
  
  def new
    # raise(params[:user].inspect)
     @title = "Sign up"
     @user = User.new
  end
  
  def index 
    @title = "All Users"
    @users = User.paginate(:page => params[:page], :per_page => 20)
    # @users = User.order("id ASC")
      # @users = User.all
  end
  
  def show
     # redirect_to root_path if !signed_in? 
     @user = User.find_by_id(params[:id])
     @microposts = @user.microposts.paginate(:page => params[:page], 
                                              :per_page => 20)
     @title = @user.name
  end
  
  def edit
    @user = User.find_by_id(params[:id])
    @title = "Update #{@user.name}"
  end
  
  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(params[:user])
      then  
          @title = @user.name
          flash[:success] = "User updated successfully"
           redirect_to @user
      else  
         @title = "User Update"
          render 'edit'
    end
              
  end
  
  def create
     # raise(params[:user].inspect)
     @user = User.new(params[:user])
     if @user.save
        @title = @user.name
        flash[:success] = "Welcome to the Sample App"
        sign_in(@user)
        # redirect_to(:action => :show, :id=> @user.id) 
         redirect_to @user
      else
        @title = "Sign up"
        render 'new'
   end # if
  end
  
  def destroy
    @user = User.find_by_id(params[:id])
    if @user.destroy
       flash[:success] = "User #{@user.name} deleted successfully"
     else 
       flash[:error] = "User was not deleted"
    end
    redirect_to users_path
  end
  
end
