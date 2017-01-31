module Bot
  module DiscordEvents
    # This event is processed each time someone PMs the bot.
    # It passes on the PM to the mod_channel and returns a reassuring message.
    module PM
      extend Discordrb::EventContainer
      pm do |event, message|
        if CONFIG.mod_channel then
          target_channel = CONFIG.mod_channel
        else
          # If we don't have a mod channel, PM it to the bot owner and
          # also remind them to set a mod channel!
          target_channel_info_response = Discordrb::API::User.create_pm(event.bot.token, CONFIG.owner)
          target_channel_info = JSON.parse(target_channel_info_response.body)
          target_channel = target_channel_info['id']
          event.bot.send_message(target_channel, "Hey, you should set my mod channel with set_mod_channel!")
        end

        event.bot.send_message(target_channel, "@everyone Received the following message from user <@#{event.author.id}>: ```#{event.content}```")
        event.respond "Thank you for your message. It has been passed on to the moderators, and they will get back to you as soon as possible."
      end
    end
  end
end
