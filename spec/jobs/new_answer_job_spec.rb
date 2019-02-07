require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:service) { double('Service::QuestionNotify') }

  before do
    allow(Services::QuestionNotify).to receive(:new).and_return(service)
  end

  it 'calls Services::QuestionNotify#send_answer' do
    expect(service).to receive(:send_answer).with(answer)
    NewAnswerJob.perform_now(answer)
  end
end
