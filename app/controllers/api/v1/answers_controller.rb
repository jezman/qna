class Api::V1::AnswersController < Api::V1::BaseController
  before_action :current_resource_owner, only: :create
  before_action :find_question, except: %i[show]

  authorize_resource Answer

  def index
    render json: @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer, serializer: AnswerShowSerializer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = @current_resource_owner

    if @answer.save
      render json: 'your answer successfully created'
    else
      payload = {
        error: 'invalid params',
        status: 400
      }

      render json: payload, status: :bad_request
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
