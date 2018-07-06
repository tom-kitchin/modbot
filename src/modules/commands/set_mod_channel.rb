require_relative('../utils')

module Bot
  module DiscordCommands
    module SetModChannel
      extend Discordrb::Commands::CommandContainer
      command(:set_mod_channel, help_available: false) do |event, channel|
        return unless event.user.id == CONFIG.owner
        channel_id = channel.gsub(/<#(.+)>/, '\1')
        begin
          ModbotUtils.message_owner(event, "Request received: set_mod_channel to #{channel_id}")
          channel_info_response = Discordrb::API::Channel.resolve(event.bot.token, channel_id)
          channel_info = JSON.parse(channel_info_response.body)
        rescue => e
          ModbotUtils.message_owner(event, "Failed to set mod channel. Error was: ```#{e}```")
          return
        end
        CONFIG.mod_channel = channel_id
        "PMs will be reported to: #{channel_info['name']}"
      end
    end
  end
end
