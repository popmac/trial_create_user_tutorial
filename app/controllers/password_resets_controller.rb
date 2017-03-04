class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "メールが送信されました"
      redirect_to root_url
    else
      flash.now[:danger] = "メールを送信できませんでした"
      render 'new'
    end
  end

  def edit
    # 最初にget_userとvalid_userが実行される
  end

  def update
    # 最初にget_userとvalid_userが実行される
    # 以下の条件分岐はpasswordのバリデーションにallow_nil: trueを設定したので追加している
    if params[:user][:password].empty?
      flash[:notice] = "パスワードの入力がありません"
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      # パスワードの再設定に成功したらreset_digestを破棄する
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "パスワードの変更が完了しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # 以下はbeforeフィルター

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 有効なユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:notice] = "URLの有効期限切れです"
        redirect_to new_password_reset_url
      end
    end
end
