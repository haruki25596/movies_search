class ReviewsController < ApplicationController
before_action :authenticate_user!

  def new
    @movie_id = params[:movie_id]
    @movie = Tmdb::Movie.detail(@movie_id)
    @reviews = @movie
    @review = Review.new(movie_id: params[:movie_id], title: @movie['title'], poster_path: @movie['poster_path'])
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      redirect_to movie_path(@review.movie_id), notice: 'あなたがレビューを投稿しました'
    else
      redirect_to request.referer
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to request.referer, alert: "あなたのレビューを削除しました"
  end

  private

  def review_params
    params.require(:review).permit(:movie_id, :title, :user_id, :body, :poster_path, :rate)
  end
end
