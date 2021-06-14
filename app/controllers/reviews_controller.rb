class ReviewsController < ApplicationController

  def new
    @movie_id = params[:movie_id]
    @movie = Tmdb::Movie.detail(@movie_id)
    @reviews = @movie
    @review = Review.new(movie_id: params[:movie_id], title: @movie['title'], poster_path: @movie['poster_path'])
  end

  def edit
  end


  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      redirect_to new_review_path(@review), notice: 'あなたがレビューを投稿しました'
    else
      redirect_to request.referer
    end
  end

  def update
    @review = Review.find(params[:id])
    @review.update(review_params)
    redirect_to request.referer, notice: "あなたがレビューを更新しました"
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to request.referer, alert: "あなたのレビューを削除しました"
  end

  private

  def review_params
    params.require(:review).permit(:movie_id, :title, :user_id, :body, :poster_path)
  end
end
