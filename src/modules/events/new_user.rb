module Bot
  module DiscordEvents
    # Logs new users and tells them about server rules.
    module NewUser
      extend Discordrb::EventContainer
      member_join do |event|
        if CONFIG.audit_channel then
          target_channel = CONFIG.audit_channel
        else
          # If we don't have a audit channel, PM it to the bot owner and
          # also remind them to set an audit channel!
          target_channel_info_response = Discordrb::API::User.create_pm(event.bot.token, CONFIG.owner)
          target_channel_info = JSON.parse(target_channel_info_response.body)
          target_channel = target_channel_info['id']
          event.bot.send_message(target_channel, "Hey, you should set my audit channel with set_audit_channel!")
        end

        # Send new user audit log.
        event.bot.send_message(target_channel, "New user: <@#{event.user.id}>")

        # Send the new user the new_user_message, if there is one set.
        if CONFIG.new_user_message then
          new_user_pms_info_response = Discordrb::API::User.create_pm(event.bot.token, event.user.id)
          new_user_pms_info = JSON.parse(new_user_pms_info_response.body)
          new_user_pms = new_user_pms_info['id']
          event.bot.send_message(new_user_pms, CONFIG.new_user_message)
        end
      end
    end
  end
end
