module Bot
  module DiscordEvents
    # This event is processed each time someone PMs the bot.
    # It passes on the PM to the mod_channel and returns a reassuring message.
    module PM
      extend Discordrb::EventContainer

      module ModbotPMCommands
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
      end

      pm do |event|
        if event.content[0] == '!' then
          args = event.content.slice(1..-1).split
          event_name = args.slice!(0).downcase.to_sym
          if ModbotPMCommands.respond_to? event_name then
            if (CONFIG.debug) then event.bot.send_message(ModbotUtils.get_owner_channel(event), "Trying to accept command #{event_name}") end
            ModbotPMCommands.send(event_name, event)
          else
            event.respond "Command `!#{event_name}` not recognised. If you were trying to reach the moderators with a message, just type it to me normally (without an ! on the beginning) :)"
          end
        else
          if CONFIG.debug then
            target_channel = ModbotUtils.get_owner_channel(event)
          elsif CONFIG.mod_channel then
            target_channel = CONFIG.mod_channel
          else
            # If we don't have a mod channel, PM it to the bot owner and
            # also remind them to set a mod channel!
            target_channel = ModbotUtils.get_owner_channel(event)
            event.bot.send_message(target_channel, "Hey, you should set my mod channel with set_mod_channel!")
          end

          event.bot.send_message(target_channel, "@everyone Received the following message from user <@#{event.author.id}>: ```#{event.content}```")
          event.respond "Thank you for your message. It has been passed on to the moderators, and they will get back to you as soon as possible."
        end
      end
    end
  end
end
