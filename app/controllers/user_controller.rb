class UserController < ApplicationController
  

  before_action :logged_in_user, only: [:edit,:update,:index, :destroy]

  before_action :correct_user,only: [:eidt, :update]
  def new
  	@user = User.new
  end

  def show
  	begin
  		@user = User.find_by id:params[:id]
  	rescue Exception => e
 		
  	end
  end
  	def destroy
  		User.find_by(id: params[:id]).destroy
 		flash[:success] = "User deleted"
 		redirect_to users_url
  				
  	end

    def index
  		@users = User.paginate(page: params[:page],per_page: 20)
    end


	def all
		@user = User.all
	end

	def edit
  		@user = User.find_by(id: params[:id])
  		p @user
	end

	def update
		
  		@user = User.find_by(id: params[:id])
  		if @user.update_attributes(user_params)
  			flash[:success] = "Profile updated"
  			redirect_to @user
  		else
  			render "edit"
  		end

	end

	def create
		@user = User.new(user_params)
		#debugger
		if @user.save
			@user.send_activation_email
			# UserMailer.account_activation(@user).deliver_now
			flash[:info] ="Please check your email to activate your account."
			redirect_to root_url
			# log_in @user
			# flash[:success] = "Welcome to the Sample App!"
			# redirect_to @user
		 else
		 	@user
		 	render :error_messages
		end

	end
	def logged_in_user
		unless logged_in?
			store_location
			flash[:danger]= "Pls Login"
			redirect_to login_url
		end
	end

	def correct_user
		@user =User.find_by(id: params[:id])
		redirect_to(root_url) unless current_user?(@user)
	end

	private 
	def user_params
		# permit chi chap nhan nhung cai thuoc tinh ma chung ta nhap vao thoi 
		params.require(:user).permit :name,:email,:password,:password_confirmation
	end


end
