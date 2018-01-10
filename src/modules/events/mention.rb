require_relative('../utils')

module Bot
  module DiscordEvents
    # This event is processed each time someone mentions the bot.
    # It just describes the bot's basic functions.
    module Mention
      extend Discordrb::EventContainer
      mention do |event|
        if CONFIG.debug then
          ModbotUtils.message_owner(event, "Mentioned with ```#{event.content}```")
        end
        stripped_message = event.content.downcase.sub("<@!#{CONFIG.client_id}>", "").sub("<@#{CONFIG.client_id}>", "").strip
        if CONFIG.debug then
          ModbotUtils.message_owner(event, "Stripped message is ```#{stripped_message}```")
        end

        if stripped_message[0] == '!' then
          args = stripped_message.slice(1..-1).split
          command_name = args.slice!(0).downcase.to_sym
          if ModbotCommands.respond_to? command_name then
            if (CONFIG.debug) then ModbotUtils.message_owner(event, "Trying to accept command #{command_name} with args #{args.join(', ')}") end
            ModbotCommands.send(command_name, event)
          else
            event.respond "Command `!#{command_name}` not recognised."
          end
        else
          event.respond CONFIG.info_message
        end
      end
    end
  end
end
