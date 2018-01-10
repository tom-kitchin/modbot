module ModbotCommands
  # Bot configuration
  if !defined? CONFIG then
    CONFIG = OpenStruct.new YAML.load_file 'data/config.yaml'
  end

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

  def listroles (event)
    if !event.server then
      event.respond "Unable to identify server - this command doesn't work in PMs :("
    end

    # The bot can hand out roles it itself has.
    roles = event.server.member(CONFIG.client_id).roles

    # Drop the bot's highest ranking role, we don't want to hand that out.
    roles = roles.sort { |x, y| y.position <=> x.position }.drop(1)

    if roles.empty? then
      event.respond "No roles available :("
    else
      event.respond "Available roles:"
      event.respond roles.map { |role| "- #{role.name}" }.join("\n")
    end
  end
end

module ModbotUtils
  # Bot configuration
  if !defined? CONFIG then
    CONFIG = OpenStruct.new YAML.load_file 'data/config.yaml'
  end

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
