require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_db_index :question_id }
  it { should have_db_index :user_id }

  it { should validate_presence_of :body }

  describe '#best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    it 'should make answer the best' do
      answer.best!
      expect(answer).to be_best
    end

    it 'should change the best answer' do
      best_answer = create(:answer, question: question, user: user, best: true)

      answer.best!
      best_answer.reload

      expect(answer).to be_best
      expect(best_answer).to_not be_best
    end

    it 'only one answer can be the best' do
      best_answer = create(:answer, question: question, user: user, best: true)

      answer.best!
      best_answer.reload

      expect(question.answers.best.count).to eq 1
    end

    it 'best answer is first in list' do
      expect(answer).to eq question.answers.first

      best_answer = create(:answer, question: question, user: user, best: true)

      expect(best_answer).to eq question.answers.first
    end
  end
end
