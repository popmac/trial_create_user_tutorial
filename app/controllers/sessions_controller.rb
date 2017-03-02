class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      remember user
      flash[:notice] = 'ログインしました。'
      redirect_to user
    else
      flash.now[:danger] = 'Eメールもしくはパスワードが正しくありません。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:notice] = 'ログアウトしました。'
    redirect_to root_path
  end
end
