class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope -> { order('best DESC, created_at') }
  scope :best, -> { where best: true }

  def best!
    transaction do
      question.answers.best.update_all(best: false)
      raise 'only one answer can be the best' if question.answers.best.count > 1
      update!(best: true)
    end
  end
end
