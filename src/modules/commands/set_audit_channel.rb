module Bot
  module DiscordCommands
    # Responds with "Pong!".
    # This used to check if bot is alive
    module SetModChannel
      extend Discordrb::Commands::CommandContainer
      command(:set_audit_channel) do |event, channel|
        channel_id = channel.gsub(/<#(.+)>/, '\1')
        begin
          channel_info_response = Discordrb::API::Channel.resolve(event.bot.token, channel_id)
          channel_info = JSON.parse(channel_info_response.body)
        rescue => e
          "Failed to set audit channel. Error was: ```#{e}```"
          return
        end
        CONFIG.audit_channel = channel_id
        "Audit log messages will be reported to: #{channel_info['name']}"
      end
    end
  end
end
