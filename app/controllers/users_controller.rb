class UsersController < ApplicationController

  def index
    @users = User.page(params[:page]).per(8)
    # @users.id
    # @users.email
    # user = User.find(1) # クラスメソッド
    # user.xxx() # インスタンスメソッド
    # User.xxx() # クラスメソッド
    # @users.id
    # @users.xxx() # クラスメソッド
    # @users.each do |user|
    #   user.xxx() # インスタンスメソッド
    # end
  end

  def show
    @user = User.find(params[:id])
    @user_goods = @user.goods
    @user_bads = @user.bads
    @user_reviews = @user.reviews
    @user_interests = Interest.where(user_id: current_user.id)

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id),notice: 'You have updated user successfully.'
    else
      render :edit
    end
  end



  private

  def user_params
    params.require(:user).permit(:name, :image, :email, :introduction)
  end

end
