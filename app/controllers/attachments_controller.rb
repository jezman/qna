class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  def destroy
    case @attachment.record_type
    when 'Question'
      question = Question.find(@attachment.record_id)

      if current_user.author?(question)
        @attachment.purge
      else
        redirect_to question
      end
    else redirect_to questions_path
    end
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
