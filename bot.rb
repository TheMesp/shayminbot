# Shaymin Shitpost Bot
# David "Mesp" Loewen

require 'discordrb'
require 'json'
require 'pp'
require_relative 'secrets.rb'
bot = Discordrb::Commands::CommandBot.new token: DISCORD_TOKEN, client_id: DISCORD_CLIENT, prefix: 's!'

def log_action(bot, event)
    bot.send_message(747908070838894633, "**#{event.author.display_name}** typed #{event.message.content.gsub('@', '')}")
end

bot.command(:hornets, description: 'You know it', usage: 's!hornets') do |event|
	event.respond "FUCK THE HORNETS"
end

bot.command(:echo, description: 'Have shaymin say whatever you say', usage: 's!echo <optional: channel to echo in> <text to be repeated>', min_args: 1) do |event, *text|
	if text[0] =~ /<#\d{2,}>/
		channel = text.shift
		channel_id = channel[/\d{2,}/]
	else
		channel_id = event.message.channel.id
	end
	text = text.join(" ").gsub('@','')
	log_action(bot, event)
	bot.send_message(channel_id, text)
    event.message.delete
end

bot.command(:praise, description: 'generate a kind compliment', usage: 's!praise <target>') do |event, *victim|
    first_word = %w(
        TRUSTWORTHY
        POPULAR
        DEFINITELY
        UNEQUIVOCALLY
        LEGENDARY
        OBVIOUSLY
        FRIENDLY
        CLEARLY
        TRULY
        POWERFULLY
    )
    second_word = %w(
        PERFECT
        NICE
        INSPIRATIONAL
        AWESOME
        KIND
        WHOLESOME\ 100
        WHOLESOME
        HELPFUL
        SUPERSTAR
        ROCKSTAR
    )
    third_word = %w(
        FRIEND
        PAL
        PARTNER
        CONTRIBUTOR
        HERO
        BUDDY
        MEMBER
        USER
        FAN
        BESTIE
    )
    event.respond "#{victim.join(" ").gsub('@','')} you are a #{first_word.sample} #{second_word.sample} #{third_word.sample}"
end

# initial setup
bot.run(true)
puts 'bot active'
bot.join
