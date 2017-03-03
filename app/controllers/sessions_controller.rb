class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "アカウントが有効化されていません。"
        message += "メールを確認してください。"
        flash[:notice] = message
        redirect_to root_url
      end
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
