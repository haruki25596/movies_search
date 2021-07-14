class RelationshipsController < ApplicationController

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    @user.create_notification_follow!(current_user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def follow
    @user = User.find(params[:id])
    current_user.follow(params[:id])
    User.find(params[:id]).create_notification_follow!(current_user)

    redirect_to user_path(@user) unless request.xhr?
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow(params[:id])

    redirect_to user_path(@user) unless request.xhr?
  end

  # フォローしている人一覧
  def follower
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(10)
  end

  # フォローされている人一覧
  def followed
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(10)
  end

end
