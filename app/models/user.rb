class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :image, destroy: false

  has_many :reviews, dependent: :destroy

  has_many :interests, dependent: :destroy
  
  has_many :review_comments, dependent: :destroy
  has_many :review_favorites, dependent: :destroy

  has_many :goods
  has_many :bads

  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy #フォロー取得
  has_many :following_user, through: :follower, source: :followed #自分がフォローしている人
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy #フォロワー取得
  has_many :follower_user, through: :followed, source: :follower #自分をフォローしている人

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy #自分からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy #相手からの通知


  validates :name,  presence: true, length: { maximum: 20 },
                    format: { with: /\A[a-zA-Z0-9]+\z/, message: "を半角英数字で入力してください"}

  def good?(movie_id)
    goods.where(movie_id: movie_id).exists?
  end

  def bad?(movie_id)
    bads.where(movie_id: movie_id).exists?
  end

  #ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  #ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  #フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        checked: false,
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
end
