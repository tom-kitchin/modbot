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
        stripped_message = event.content.downcase.sub("<@#{CONFIG.client_id}>", "").strip
        if CONFIG.debug then
          ModbotUtils.message_owner(event, "Stripped message is ```#{stripped_message}```")
        end

        if event.content.downcase.include? "!rules" then
          event.respond CONFIG.rules_message
        elsif event.content.downcase.include? "!new" then
          event.respond CONFIG.new_user_message
        elsif event.content.downcase.include? "!help" then
          event.respond CONFIG.help_message
        else
          event.respond CONFIG.info_message
        end
      end
    end
  end
end
