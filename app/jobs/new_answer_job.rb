class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::QuestionNotify.new.send_answer(answer)
  end
end
