module NotificationsHelper
  def notification_form(notification)
    @comment = nil
    visitor = link_to notification.visitor.name, notification.visitor, style:"font-weight: bold;"
    your_post = link_to 'あなたの投稿', notification.review, style:"font-weight: bold;", remote: true
    case notification.action
      when "follow" then
        "#{visitor}があなたをフォローしました"
      when "review_favorite" then
        "#{visitor}が#{your_post}にいいね！しました"
      when "review_comment" then
        @comment=ReviewComment.find_by(id:notification.review_comment_id)&.content
        "#{visitor}が#{your_post}にコメントしました"
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end

