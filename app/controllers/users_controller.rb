class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in(@user)
      flash[:success] = "Welcome dear!"
  		# redirect_to @user
      redirect_to user_url(@user)
  	else
  		render "new"
  	end  	
  end

  def show
  	@user = User.find(params[:id])  	    
  end

  def index
    @users = User.all
    # respond_to do |format|
    #   format.json {render :json => @users}      
    # end
    respond_to :json
    respond_with (@users)

  end


  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)  	
  	end
end
