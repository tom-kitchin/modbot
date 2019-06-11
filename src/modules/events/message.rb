require_relative('../utils')

module Bot
  module DiscordEvents
    # This event is processed each time someone mentions the bot.
    # It just describes the bot's basic functions.
    module Message
      extend Discordrb::EventContainer
      message(start_with: CONFIG.prefix) do |event|
        args = event.content.downcase.strip.slice(1..-1).split
        command_name = args.slice!(0).downcase.to_sym
        if ModbotCommands.respond_to? command_name
          ModbotCommands.send(command_name, event, *args)
        end
      end
    end
  end
end
