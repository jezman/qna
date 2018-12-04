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

  private

  def flash_type(type)
    "alert alert-#{FLASH_TYPES[type.to_sym]}"
  end
end
