class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:notice] = "アカウントを有効化するためにメールを確認してください"
      redirect_to users_path
    else
      flash.now[:success] = 'アカウント登録に失敗しました'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報の編集ができました"
      redirect_to @user
    else
      flash.now[:notice] = "ユーザー情報の編集に失敗しました"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:notice] = "ログインしてください"
        redirect_to users_path
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end
