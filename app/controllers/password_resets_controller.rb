class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

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

  private
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
end
