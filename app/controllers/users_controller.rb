class UsersController < ApplicationController

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = 'アカウント登録が完了しました'
      redirect_to users_path
    else
      flash.now[:success] = 'アカウント登録に失敗しました'
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報の編集ができました"
      redirect_to @user
    else
      flash.now[:notice] = "ユーザー情報の編集に失敗しました"
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
