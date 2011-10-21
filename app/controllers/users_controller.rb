class UsersController < ApplicationController
  def new
    # raise(params[:user].inspect)
     @title = "Sign up"
     @user = User.new
  end
  
  def show
     @user = User.find_by_id(params[:id])
     @title = @user.name
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
end
