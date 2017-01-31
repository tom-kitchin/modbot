module Bot
  module DiscordEvents
    # This event is processed each time someone mentions the bot.
    # It just describes the bot's basic functions.
    module Info
      extend Discordrb::EventContainer
      mention do |event|
        event.respond "Hello! I'm Modbot, a support bot for moderating this server. If you have a concern or query you'd like to raise with the moderators privately, just PM me and I'll pass on your message. An active moderator will get back to you as soon as possible."
      end
    end
  end
end
