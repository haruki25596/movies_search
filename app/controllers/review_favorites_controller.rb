class ReviewFavoritesController < ApplicationController

before_action :authenticate_user!

  def create
    review = Review.find(params[:review_id])
    favorite = current_user.review_favorites.new(review_id: review.id)
    favorite.save
    review.create_notification_review_favorite!(current_user.id, review.user_id, review.id)
    redirect_to movie_path(review.movie_id)
  end

  def destroy
    review = Review.find(params[:review_id])
    favorite = current_user.review_favorites.find_by(review_id: review.id)
    favorite.destroy
    redirect_to movie_path(review.movie_id)
  end

end
