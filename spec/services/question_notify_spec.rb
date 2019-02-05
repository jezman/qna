require 'rails_helper'

RSpec.describe Services::QuestionNotify do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'sends daily digest to all users' do
    expect(QuestionNotifyMailer).to receive(:new_answer).with(answer).and_call_original

    subject.send_answer(answer)
  end
end
