class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show update destroy delete_file]
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
    if current_user.author?(@question)
      @question.update(question_params)
    else
      render :show
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted.'
    else
      redirect_to @question, notice: 'Only author can delete question.'
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
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
end
