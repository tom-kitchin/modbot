require_relative('../utils')

module Bot
  module DiscordEvents
    # Logs new users and tells them about server rules.
    module NewUser
      extend Discordrb::EventContainer
      member_join do |event|
        if CONFIG.audit_channel
          target_channel = CONFIG.audit_channel
        else
          # If we don't have a audit channel, PM it to the bot owner and
          # also remind them to set an audit channel!
          target_channel = ModbotUtils.get_owner_channel(event)
          ModbotUtils.message_owner(event, "Hey, you should set my audit channel with set_audit_channel!")
        end

        # Send new user audit log.
        event.bot.send_message(target_channel, "New user: <@#{event.user.id}>")

        # Send the new user the new_user_message, if there is one set.
        if CONFIG.send_new_user_message_on_join && CONFIG.new_user_message
          new_user_pms_info_response = Discordrb::API::User.create_pm(event.bot.token, event.user.id)
          new_user_pms_info = JSON.parse(new_user_pms_info_response.body)
          new_user_pms = new_user_pms_info['id']
          event.bot.send_message(new_user_pms, CONFIG.new_user_message)
        end
      end
    end
  end
end
