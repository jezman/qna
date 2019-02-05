class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  authorize_resource

  def create
    @question.subscribe(current_user)

    flash[:notice] = 'Your subscribed.'
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
