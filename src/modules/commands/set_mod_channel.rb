module Bot
  module DiscordCommands
    # Responds with "Pong!".
    # This used to check if bot is alive
    module SetModChannel
      extend Discordrb::Commands::CommandContainer
      command(:set_mod_channel) do |event, channel|
        channel_id = channel.gsub(/<#(.+)>/, '\1')
        begin
          channel_info_response = Discordrb::API::Channel.resolve(event.bot.token, channel_id)
          channel_info = JSON.parse(channel_info_response.body)
        rescue => e
          "Failed to set mod channel. Error was: ```#{e}```"
          return
        end
        CONFIG.mod_channel = channel_id
        "PMs will be reported to: #{channel_info['name']}"
      end
    end
  end
end
