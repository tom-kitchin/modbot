module ModbotCommands
  module_function

  def rules (event)
    event.respond CONFIG.rules_message
  end

  def new (event)
    event.respond CONFIG.new_user_message
  end

  def help (event)
    event.respond CONFIG.help_message
  end
end

module ModbotUtils
  module_function

  def get_owner_channel (event)
    target_channel_info_response = Discordrb::API::User.create_pm(event.bot.token, CONFIG.owner)
    target_channel_info = JSON.parse(target_channel_info_response.body)
    return target_channel_info['id']
  end

  def message_owner (event, message)
    target_channel = get_owner_channel(event)
    event.bot.send_message(target_channel, message)
  end
end
