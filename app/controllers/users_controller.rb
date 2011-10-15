class UsersController < ApplicationController
  def new
     @title = "Sign up"
  end
  
  def show
     @title = "Show User"
     @user = User.find_by_id(params[:id])
  end

end
