# Shaymin Shitpost Bot
# David "Mesp" Loewen

require 'discordrb'
require 'json'
require 'pp'
require_relative 'secrets.rb'
bot = Discordrb::Commands::CommandBot.new token: DISCORD_TOKEN, client_id: DISCORD_CLIENT, prefix: 's!'

def log_action(bot, event)
    bot.send_message(747908070838894633, "#{event.author.display_name} typed #{event.message.content}")
end

bot.command(:echo) do |event, *text|
    text = text.join(" ")
    event.respond text
    event.message.delete
end

# initial setup
bot.run(true)
puts 'bot active'
bot.join
