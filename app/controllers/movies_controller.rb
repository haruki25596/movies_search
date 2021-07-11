class MoviesController < ApplicationController
  before_action :redirect_root, except: [:index, :show, :search]

  require 'themoviedb-api'
  Tmdb::Api.key("6ce86077881a441d243745e068c0f6dc")
  Tmdb::Api.language("ja") # 映画情報の表示の際の言語設定を日本語にできる

  def index
    @tmdbs = JSON.parse(Tmdb::Movie.upcoming.to_json)
  end

  def search
    if params[:keyword].present?
      @tmdbs= JSON.parse(Tmdb::Search.movie(params[:keyword]).to_json)
    else
      @tmdbs = JSON.parse(Tmdb::Movie.upcoming.to_json)
    end
  end

  def show
    @movie = Tmdb::Movie.detail(params[:id])
    @reviews = Review.where(movie_id: params[:id]).page(params[:page]).per(8)
    @total_reviews = Review.where(movie_id: params[:id])
    @goods_count = Good.where(movie_id: params[:id]).count
    @bads_count = Bad.where(movie_id: params[:id]).count
  end

  def movie_params
    params.require(:movie).permit(:title, :body, :user_id)
  end

  private

  def redirect_root
    redirect_to new_user_session_path unless user_signed_in?
  end

end
