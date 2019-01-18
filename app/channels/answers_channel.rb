class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "question_#{params['id']}_answers"
  end
end
