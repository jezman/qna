class Answer < ApplicationRecord
  MAX_BEST_ANSWERS_COUNT = 1

  belongs_to :question
  belongs_to :user
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true
  validate :best_count, on: :best

  default_scope -> { order('best DESC, created_at') }
  scope :best, -> { where(best: true) }

  def best!
    transaction do
      question.answers.best.update_all(best: false)
      update!(best: true)
    end
  end

  private

  def best_count
    errors.add(:answer, 'only one answer can be the best') if question.answers.best.count > MAX_BEST_ANSWERS_COUNT
  end
end
