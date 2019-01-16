class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :badges
  has_many :likes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(obj)
    obj.user_id == id
  end

  def award_badge!(badge)
    badges << badge
  end

  def liked?(item_id)
    likes.exists?(likable_id: item_id)
  end
end
