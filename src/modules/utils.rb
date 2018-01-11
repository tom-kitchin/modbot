module ModbotCommands
  # Bot configuration
  CONFIG = OpenStruct.new YAML.load_file 'data/config.yaml' unless defined? CONFIG

  def available_roles (event)
    # The bot can hand out roles it itself has.
    roles = event.server.member(CONFIG.client_id).roles

    # Drop the bot's highest ranking role, we don't want to hand that out.
    roles = roles.sort { |x, y| y.position <=> x.position }.drop(1)

    return roles
  end

  def server_only (event)
    event.respond "Unable to identify server - this command doesn't work in PMs :disappointed:"
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

  def good_boy (event)
    if event.user.mention
      event.respond "#{event.user.mention} :hearts:"
    else
      event.respond ":hearts"
    end
  end

  def listroles (event)
    return server_only unless event.server

    roles = available_roles(event)

    if roles.empty?
      event.respond "No roles available :("
    else
      event.respond "Available roles:"
      event.respond roles.map { |role| "- #{role.name}" }.join("\n")
      event.respond "Claim a role with !getrole <rolename>."
    end
  end

  def getrole (event, rolename)
    return server_only unless event.server

    roles = available_roles(event)

    role = roles.find { |role| role.name == rolename }

    return event.respond "Role #{rolename} not available." unless role

    event.user.add_role(role)
    event.respond "#{event.user.mention} Role granted!"
  end

  def droprole (event, rolename)
    return server_only unless event.server

    roles = available_roles(event)

    role = roles.find { |role| role.name == rolename }

    return event.respond "I can't do anything with role #{rolename} :cry:" unless role

    role = event.user.roles.find { |role| role.name == rolename }

    return event.respond "#{event.user.mention} You don't have the role #{rolename} to remove!" unless role

    event.user.remove_role(role)
    event.respond "#{event.user.mention} Role removed!"
end

module ModbotUtils
  # Bot configuration
  CONFIG = OpenStruct.new YAML.load_file 'data/config.yaml' unless defined? CONFIG

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
