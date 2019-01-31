class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :current_resource_owner, only: :create
  authorize_resource Question

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    render json: @question, serializer: QuestionShowSerializer
  end

  def create
    @current_resource_owner.questions.new(question_params)

    if @current_resource_owner.save
      render json: 'your question successfully created'
    else
      payload = {
        error: 'invalid params',
        status: 400
      }

      render json: payload, status: :bad_request
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
