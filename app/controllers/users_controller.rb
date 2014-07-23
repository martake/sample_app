class UsersController < ApplicationController

  before_action :signed_in_user, 
                 only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,    only: :destroy
  before_action :unsigned_in_user, only: [:new, :create]

  def show
   @user = User.find(params[:id])
   @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
   @user = User.new
  end

  def create
   @user = User.new(user_params)
   if @user.save
     @user.send_email_confirm
     flash[:success] = "Send Confirm Mail to Your Address"
     redirect_to root_path
   else
     render 'new'
   end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_change_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    if current_user.id.to_s == params[:id]
      flash[:error] = "Don't destroy yourself!"
      redirect_to users_url
    else
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def email_confirm
    @user = User.find_by(email_confirm_token: params[:id])

    unless @user.nil?
      @user.confirmed
      sign_in @user
      flash[:success] = "Welcome to App!"
      redirect_to @user
    else
      flash[:error] = "No Match URL"
      redirect_to root_url

    end

  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :key, :followup_mail, 
                                   :password_confirmation)
    end

    def user_change_params
      params.require(:user).permit(:name, :password, :key, :followup_mail, 
                                   :password_confirmation)
    end

    #before actions

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def unsigned_in_user
      redirect_to root_url, notice: "You are already signin." if signed_in?
    end

end
