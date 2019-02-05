class Services::QuestionNotify
  def send_answer(answer)
    QuestionNotifyMailer.new_answer(answer).deliver_later
  end
end
