module SessionsHelper
  def sign_in (user)
   # cookies.permanent.signed[:remember_token] = [user.id, user.salt]
   session[:user_id] = user.id
   session[:salt] = user.salt
   session[:last_seen] = Time.now
   current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def signed_in?
     true if current_user && session[:last_seen] > 2.hours.ago
  end
   
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def sign_out
     cookies.delete(:remember_token)
     session[:user_id] = nil
     session[:salt] = nil
     session[:last_seen] = nil
     self.current_user = nil
  end
  
  private
  def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
  end
  
  def remember_token
     # cookies.signed[:remember_token] || [nil, nil]
     [session[:user_id], session[:salt]]|| [nil, nil]
  end
  
  def validate_login
    session[:original_req] = request.fullpath
    if signed_in?
    then 
      session[:original_req] = nil
    else
      flash[:notice] ="Please sign in to access this page."
      redirect_to signin_path
    end
  end
  
  def redirect_to_original_req
     if session[:original_req]
       redirect_to session[:original_req]
     else
       redirect_to current_user
     end
  end
def validate_login_match_user
  user = User.find(params[:id])
  if current_user != user
    flash[:notice] ="You can only update your own profile"
    redirect_to (root_path)
  end
end
end
