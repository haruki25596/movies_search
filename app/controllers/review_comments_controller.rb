class ReviewCommentsController < ApplicationController

  def new
    @review_comment = ReviewComment.new
    @review_comments = ReviewComment.all
  end

  def create
    review = Review.find(params[:review_id])
    comment = current_user.review_comments.new(review_comment_params)
    comment.review_id = review.id
    comment.save
    redirect_to new_review_review_comments_path(review)
  end

  def destroy
    ReviewComment.find_by(id: params[:id], review_id: params[:review_id]).destroy
    redirect_to new_review_review_comments_path(params[:review_id])
  end

  private

  def review_comment_params
    params.require(:review_comment).permit(:comment, :user_id, :review_id)
  end

end
