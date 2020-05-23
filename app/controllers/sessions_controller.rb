class SessionsController < ApplicationController
  def new
  end

  def create
  	user= User.find_by email:params[:session][:email].downcase
	 if user.try(:authenticate, params[:session][:password])
    	 log_in user
       params[:session][:remember_me] == '1' ? remember(user) : forget(user) 
       redirect_back_or user
     		# redirect_to user
 	  else
	     flash.now[:danger] = "Account not activated. Check your email for the activation link"
 	     redirect_to root_url
	  end
  end

  def destroy
    log_out
 	  redirect_to root_url
  end

  def current_user
    if (user_id = session[:user_id])
        @current_user ||= User.find_by id: user_id 
      elsif (user_id = cookies.signed[:user_id])
          user = User.find_by id: user_id
          if user&.authenticated?(cookies[:remember_token])
              log_in user
              @current_user = user 
          end
      end 
  end

 
end

