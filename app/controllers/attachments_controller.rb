class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  def destroy
    case @attachment.record_type
    when 'Question' then destroy!(Question.find(@attachment.record_id))
    when 'Answer' then destroy!(Answer.find(@attachment.record_id))
    else redirect_to questions_path
    end
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def destroy!(item)
    if current_user.author?(item)
      @attachment.purge
    else
      redirect_to item.is_a?(Question) ? item : item.question
    end
  end
end
