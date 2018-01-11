require_relative('../utils')

module Bot
  module DiscordEvents
    # This event is processed each time someone PMs the bot.
    # It passes on the PM to the mod_channel and returns a reassuring message.
    module PM
      extend Discordrb::EventContainer

      pm do |event|
        if event.content[0] == '!'
          args = event.content.slice(1..-1).split
          event_name = args.slice!(0).downcase.to_sym
          if ModbotCommands.respond_to? event_name
            if (CONFIG.debug)
              ModbotUtils.message_owner(event, "Trying to accept command #{event_name} with args #{args.join(', ')}")
            end
            ModbotCommands.send(event_name, event, *args)
          else
            event.respond "Command `!#{event_name}` not recognised. If you were trying to reach the moderators with a message, just type it to me normally (without an ! on the beginning) :)"
          end
        else
          if CONFIG.debug
            target_channel = ModbotUtils.get_owner_channel(event)
          elsif CONFIG.mod_channel
            target_channel = CONFIG.mod_channel
          else
            # If we don't have a mod channel, PM it to the bot owner and
            # also remind them to set a mod channel!
            ModbotUtils.message_owner(event, "Hey, you should set my mod channel with set_mod_channel!")
          end

          event.bot.send_message(target_channel, "@everyone Received the following message from user <@#{event.author.id}>: ```#{event.content}```")
          event.respond "Thank you for your message. It has been passed on to the moderators, and they will get back to you as soon as possible."
        end
      end
    end
  end
end
