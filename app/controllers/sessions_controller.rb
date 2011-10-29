class SessionsController < ApplicationController
  
  def new
  @title = "Sign In"  
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user
       sign_in (user)
       # redirect_to user
       redirect_to_original_req
     else
       flash.now[:error] = " Invalid email/password combination"
       @title = "Sign In"
       render ('new')
     end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
