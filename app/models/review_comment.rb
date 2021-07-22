class ReviewComment < ApplicationRecord

  belongs_to :user
  belongs_to :review

  has_many :notifications, dependent: :destroy

  def set_date
    created_at.strftime("%Y年%m月%d日%H時%M分")
  end

end
