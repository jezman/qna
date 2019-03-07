module ApplicationHelper
  FLASH_TYPES = {
    alert: 'warning',
    notice: 'info'
  }.freeze

  def flash_messages
    flash.map do |type, message|
      content_tag :div, sanitize(message), class: flash_type(type), role: 'alert'
    end.join("\n").html_safe
  end

  def link_cache_key(link)
    link_type = link.gist? ? 'gist' : 'simple'

    "links/#{link.id}/#{link_type}-#{link.updated_at.to_f}"
  end

  def answer_cache_key(answer)
    answer_type = answer.best? ? 'best' : 'simple'

    "answers/#{answer.id}/#{answer_type}-#{answer.updated_at.to_f}"
  end

  private

  def flash_type(type)
    "alert alert-#{FLASH_TYPES[type.to_sym]}"
  end
end
