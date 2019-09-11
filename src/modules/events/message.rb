require_relative('../utils')

module Bot
  module DiscordEvents
    # This event is processed on all messages.
    # Honestly it triggers IN ADDITION TO matching events like mention or PM in the relevant
    # contexts. There are bugs here, one day I may even fix them.
    # Anyway if you see doubling responses from modbot, check here first.
    module Message
      extend Discordrb::EventContainer
      message(start_with: CONFIG.prefix) do |event|
        # This event now also triggers in PMs, so bin _that_ off.
        return unless event.server

        args = event.content.downcase.strip.slice(1..-1).split
        command_name = args.slice!(0).downcase.to_sym
        if ModbotCommands.respond_to? command_name
          ModbotCommands.send(command_name, event, *args)
        end
      end
    end
  end
end
