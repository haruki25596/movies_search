class ReviewFavoritesController < ApplicationController

  def create
    review = Review.find(params[:review_id])
    favorite = current_user.review_favorites.new(review_id: review.id)
    favorite.save
    redirect_to movie_path(review.movie_id)
  end

  def destroy
    review = Review.find(params[:review_id])
    favorite = current_user.review_favorites.find_by(review_id: review.id)
    favorite.destroy
    redirect_to movie_path(review.movie_id)
  end

end
