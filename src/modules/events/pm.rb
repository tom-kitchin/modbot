require_relative('../utils')

module Bot
  module DiscordEvents
    # This event is processed each time someone PMs the bot.
    # It passes on the PM to the mod_channel and returns a reassuring message.
    module PM
      extend Discordrb::EventContainer

      pm do |event|
        if CONFIG.debug
          ModbotUtils.message_owner(event, "PM'd with ```#{event.content}```")
        end
        stripped_message = event.content.downcase.sub("<@!#{CONFIG.client_id}>", "").sub("<@#{CONFIG.client_id}>", "").sub("@modbot", "").strip
        if CONFIG.debug
          ModbotUtils.message_owner(event, "Stripped message is ```#{stripped_message}```")
        end

        if stripped_message[0] == CONFIG.prefix
          args = stripped_message.slice(1..-1).split
          event_name = args.slice!(0).downcase.to_sym
          if ModbotCommands.respond_to? event_name
            if (CONFIG.debug)
              ModbotUtils.message_owner(event, "Trying to accept command #{event_name} with args #{args.join(', ')}")
            end
            ModbotCommands.send(event_name, event, *args)
          else
            event.respond "Command `#{CONFIG.prefix}#{event_name}` not recognised. Say `!help` for my command list."
          end
        else
          event.respond CONFIG.info_message
          event.respond "Also, if you were trying to PM the mods, the command you want is now `!message_mods your message goes here` or `!message_mods_anon message here` if you'd like to contact us anonymously."
        end
      end
    end
  end
end
