class QuestionsController < ApplicationController
  include Liked

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show update destroy delete_file]
  before_action :current_user_to_gon, only: %i[index show]
  before_action :init_comment, only: %i[show update]

  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.badge ||= Badge.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question successfully deleted.'
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def current_user_to_gon
    gon.current_user = current_user
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      @question.to_json(include: :user)
    )
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: [:name, :url],
      badge_attributes: [:title, :image]
    )
  end

  def init_comment
    @comment = Comment.new
  end
end
