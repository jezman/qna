class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.per_day

    mail to: user.email
  end
end
