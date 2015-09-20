class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: user_session_params[:email])
    if @user && @user.authenticate(user_session_params[:password])
      log_in_user(@user)
      flash[:notice] = "Login Successful!"
      redirect_to root_url
    elsif @user
      flash[:password_error] = "Incorrect password"
      redirect_to root_url
    else
      @user = User.new(user_session_params)
      flash[:auth_error] = "Email not found"
      redirect_to root_url
    end
  end

  def destroy
    log_out_user
    flash[:notice] = "You have successfully logged out."
    redirect_to root_path
  end

  private

  def user_session_params
    params.require(:user_session).permit(:email, :password)
  end
end

