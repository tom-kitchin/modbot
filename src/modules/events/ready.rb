module Bot
  module DiscordEvents
    # This event is processed each time the bot successfully connects to discord.
    module Ready
      extend Discordrb::EventContainer
      ready do |event|
        event.bot.game = CONFIG.game

        if CONFIG.audit_channel then
          event.bot.send_message(CONFIG.audit_channel, "_reconnected_")
        end
      end
    end
  end
end
