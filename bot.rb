# Shaymin Shitpost Bot
# David "Mesp" Loewen

require 'discordrb'
require 'json'
require 'pp'
require_relative 'secrets.rb'
require_relative 'classes.rb'

bot = Discordrb::Commands::CommandBot.new token: DISCORD_TOKEN, client_id: DISCORD_CLIENT, prefix: 's!'

def log_action(bot, event)
    bot.send_message(747908070838894633, "**#{event.author.display_name}** typed #{event.message.content.gsub('@', '')}")
end

bot.command(:hornets, description: 'You know it', usage: 's!hornets') do |event|
	event.respond "FUCK THE HORNETS"
end

bot.command(:quotes) do |event, *filter|
    unless @mutex
        @mutex = true
        filter = filter.join(' ')
        event.respond("Scanning quotes, this can take 15-30 seconds...")
        quotes_channel = event.server.channels.select{|channel| channel.id == 746958219368202310}
        quotes_channel = quotes_channel.pop
        quotes = []
        next_id = nil
        loop do
            chunk = quotes_channel.history(100, next_id)
            next_id = chunk.last.id
            quotes += chunk
            print "chunk length: #{quotes.length}\n"
            if chunk.length < 100
                break
            end 
        end
        quotes = quotes.select{|quote| quote.embeds[0]&.author&.name&.include? filter} if filter
        if quotes.length > 0
            quotes = quotes.sort_by { |quote| -quote.content.split("#")[1].to_i }
            description = "Top 10 quotes"
            description += " by #{filter}" if filter
            description += "\n"
            quotes.first(10).each do |quote|
                description += "#{quote.embeds[0]&.author&.url} by **#{quote.embeds[0]&.author&.name}**\n"
            end
            @mutex = false
            event.respond(description)
        else
            @mutex = false
            event.respond("Didn't find any quotes by #{filter.gsub('@','')}. I check what you give as a filter against what Quotebot has as the username, so take a look at that to see if it matches.")
        end
        
    else
        event.respond "Please wait your turn."
    end
end

bot.command(:unlock) do |event|
    @mutex = false
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
@mutex = false
bot.run(true)
puts 'bot active'
bot.join
