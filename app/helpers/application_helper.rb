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

  # NOTE: this works with standard string messages and iterables (hashes, arrays, etc.)
  def render_alerts(notifications = flash.to_hash, closeable = true)
    flashes = []

    notifications.each do |type, content|
      content = [content] unless content.respond_to? 'each'
      content.each do |message|
        flashes << render(partial: 'notify_alert', locals: {
          type: type,
          content: message,
          closeable: closeable
        })
      end
    end

    safe_join(flashes, "\n")
  end
end
