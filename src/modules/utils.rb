module ModbotCommands
  extend self

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

  def pm_only (event)
    event.respond "This command only works in private messages to me, I'm afraid."
  end

  module_function

  def rules (event, *_)
    event.respond CONFIG.rules_message
  end

  def new (event, *_)
    event.respond CONFIG.new_user_message
  end

  def help (event, *_)
    event.respond CONFIG.help_message
  end

  def message_mods (event, *_)
    return pm_only if event.server

    # if CONFIG.debug
    #   target_channel = ModbotUtils.get_owner_channel(event)
    # elsif CONFIG.mod_channel
    #   target_channel = CONFIG.mod_channel
    # else
    #   # If we don't have a mod channel, PM it to the bot owner and
    #   # also remind them to set a mod channel!
    #   ModbotUtils.message_owner(event, "Hey, you should set my mod channel with set_mod_channel!")
    # end

    # DEBUG
    target_channel = ModbotUtils.get_owner_channel(event)

    message = event.content.sub("#{CONFIG.prefix}event", "").lstrip

    event.bot.send_message(target_channel, "@everyone Received the following message from user <@#{event.author.id}>:")
    event.bod.send_message(target_channel, "> #{message}")
    event.respond "Thank you for your message. It has been passed on to the moderators, and they will get back to you as soon as possible."
  end

  def message_mods_anon (event, *_)
    return pm_only if event.server

    # if CONFIG.debug
    #   target_channel = ModbotUtils.get_owner_channel(event)
    # elsif CONFIG.mod_channel
    #   target_channel = CONFIG.mod_channel
    # else
    #   # If we don't have a mod channel, PM it to the bot owner and
    #   # also remind them to set a mod channel!
    #   ModbotUtils.message_owner(event, "Hey, you should set my mod channel with set_mod_channel!")
    # end

    # DEBUG
    target_channel = ModbotUtils.get_owner_channel(event)

    message = event.content.sub("#{CONFIG.prefix}event", "").lstrip

    event.bot.send_message(target_channel, "@everyone Received the following message anonymously:")
    event.bod.send_message(target_channel, "> #{message}")
    event.respond "Thank you for your message. It has been passed on to the moderators anonymously."
  end

  def good_boy (event, *_)
    if event.user.mention
      event.respond "#{event.user.mention} :hearts:"
    else
      event.respond ":hearts"
    end
  end

  def listroles (event, *_)
    return server_only unless event.server

    roles = available_roles(event)

    if roles.empty?
      event.respond "No roles available :("
    else
      event.respond "Available roles:"
      event.respond roles.map { |role| "- #{role.name}" }.join("\n")
      event.respond "Claim a role with `@ModBot #{CONFIG.prefix}getrole <rolename>`."
    end
  end

  def getrole (event, rolename, *_)
    return server_only unless event.server

    roles = available_roles(event)

    role = roles.find { |role| role.name.downcase == rolename.downcase }

    return event.respond "Role #{rolename} not available." unless role

    begin
      event.user.add_role(role)
      event.respond "Role granted!"
    rescue => e
      ModbotUtils.message_owner(event, "Failed to add role. Error was: ```#{e}```")
      event.respond "Failed to add role due to an internal error :cry:"
    end
  end

  def droprole (event, rolename, *_)
    return server_only unless event.server

    roles = available_roles(event)

    role = roles.find { |role| role.name.downcase == rolename.downcase }

    return event.respond "I can't do anything with that role :cry:" unless role

    role = event.user.roles.find { |role| role.name.downcase == rolename.downcase }

    return event.respond "You don't have that role to remove!" unless role

    begin
      event.user.remove_role(role)
      event.respond "Role removed!"
    rescue => e
      ModbotUtils.message_owner(event, "Failed to drop role. Error was: ```#{e}```")
      event.respond "Failed to drop role due to an internal error :cry:"
    end
  end
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
