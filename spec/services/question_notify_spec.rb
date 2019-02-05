require 'rails_helper'

RSpec.describe Services::QuestionNotify do
  let(:subscribers) { create_list(:user, 3) }
  let(:question) { create(:question, user: subscribers.first) }
  let(:answer_author) { create(:user) }
  let(:answer) { create(:answer, question: question, user: answer_author) }

  it 'send question notification for all subscribers' do
    question.subscribe(subscribers[1])
    question.subscribe(subscribers[2])

    subscribers.each do |user|
      expect(QuestionNotifyMailer).to receive(:new_answer).with(user, answer).and_call_original
    end

    subject.send_answer(answer)
  end
end
