class QuestionNotifyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.question_notify_mailer.new_answer.subject
  #
  def new_answer(user, answer)
    @answer = answer
    @question = answer.question
    @owner = answer.user

    mail to: user.email
  end
end
