# Preview all emails at http://localhost:3000/rails/mailers/question_notify
class QuestionNotifyPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/question_notify/new_answer
  def new_answer
    QuestionNotifyMailer.new_answer
  end

end
