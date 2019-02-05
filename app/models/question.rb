class Question < ApplicationRecord
  include Commentable
  include Likable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many_attached :files, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  has_one :badge, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  after_create { subscribe(user) }

  scope :per_day, -> { where(created_at: Date.today.all_day) }

  validates :title, :body, presence: true

  def subscribe(user)
    subscriptions.create(user: user)
  end

  private

  def subscribed?
    subscriptions.exists?(user: user)
  end
end
