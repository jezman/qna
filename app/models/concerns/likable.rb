module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, dependent: :destroy, as: :likable
  end

  def vote_up(user)
    likes.create!(user: user, rating: 1) unless liked?(user)
  end

  def vote_down(user)
    likes.create!(user: user, rating: -1) unless liked?(user)
  end

  def rating_sum
    likes.sum(:rating)
  end

  def liked?(user)
    likes.exists?(user: user)
  end
end
