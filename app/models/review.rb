class Review < ApplicationRecord

  belongs_to :user
  
  has_many :notifications, dependent: :destroy
  
  has_many :review_comments, dependent: :destroy
  
  has_many :review_favorites, dependent: :destroy

  def review_favorited_by?(user)
    review_favorites.where(user_id: user.id).exists?
  end


  # goodsの中に、引数で渡されたuserのidを持つレコードがあるかの判定をする
  def good_by?(user)
    goods.where(user_id: user.id).exists? # exists?の方がいいかも
  end

  # badsの中に、引数で渡されたuserのidを持つレコードがあるかの判定をする
  def bad_by?(user)
    bads.where(user_id: user.id).exists? # exists?の方がいいかも
  end

  validates :body, length: { maximum: 2000 }

  validates :rate, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true

  def create_notification_interest!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and review_id = ? and action = ? ", current_user.id, user_id, id, 'interest'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        review_id: id,
        visited_id: user_id,
        action: 'interest'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_post_comment!(current_user, post_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = PostComment.select(:user_id).where(review_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_post_comment!(current_user, post_comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_post_comment!(current_user, post_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_post_comment!(current_user, post_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      review_id: id,
      post_comment_id: comment_id,
      visited_id: visited_id,
      action: 'post_comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end
