module ApplicationHelper
  def tf_to_yn(status = false, capitalize = true)
    output = status ? 'yes' : 'no'
    capitalize ? output.capitalize : output
  end

  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
    when :error, :alert, :danger
      ' alert-danger '
    when :warning
      ' alert-warning '
    when :success, :notice
      ' alert-success '
    else
      ' alert-info '
    end
  end

  # NOTE: this works with standard string messages and arrays of messages
  def render_alerts(closeable = true)
    alerts = []

    flash.each do |type, content|
      next if content.blank?
      Array.wrap(content).each do |message|
        next if message.blank?
        alerts << render(partial: 'notify_alert', locals: {
          type: type,
          content: message,
          closeable: closeable
        })
      end
    end

    safe_join(alerts, "\n")
  end
end
