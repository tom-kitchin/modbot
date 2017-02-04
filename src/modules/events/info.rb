module Bot
  module DiscordEvents
    # This event is processed each time someone mentions the bot.
    # It just describes the bot's basic functions.
    module Info
      extend Discordrb::EventContainer
      mention do |event|
        if event.message.downcase.include? "!rules" then
          event.respond CONFIG.rules_message
        else
          event.respond CONFIG.info_message
        end
      end
    end
  end
end
