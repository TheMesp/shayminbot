# Shaymin Shitpost Bot
# David "Mesp" Loewen

require 'discordrb'
require 'json'
require 'pp'
require 'sqlite3'
require_relative 'secrets.rb'
require_relative 'classes.rb'

bot = Discordrb::Commands::CommandBot.new token: DISCORD_TOKEN, client_id: DISCORD_CLIENT, prefix: 's!'

def log_action(bot, event)
    bot.send_message(747908070838894633, "**#{event.author.display_name}** typed #{event.message.content.gsub('@', '')}")
end

bot.command(:hornets, description: 'You know it', usage: 's!hornets') do |event|
	event.respond "FUCK THE HORNETS"
end

def opendb
	return SQLite3::Database.new "/root/discordbots/shayminbot/shaymindb.db"
end

bot.command(:fillquotes) do |event|
    if(event.channel.id == 747908070838894633)
        print "Creating tables..."
        event.respond("Trying to grab quotes history, this sometimes fails because discord is stupid...")
        
        quotes_channel = event.server.channels.select{|channel| channel.name == 'quotes'}
        print(quotes_channel)
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
        db = opendb
        db.execute <<-SQL
            DROP TABLE IF EXISTS quotes;
        SQL
        db.execute <<-SQL
            CREATE TABLE quotes(
                link varchar(100) NOT NULL PRIMARY KEY,
                userid varchar(30),
                username varchar(30),
                score integer
            );
        SQL
        event.respond("History obtained. Reloading quote DB, this may take a long while...")
        # Load in each message individually... please don't murder me ratelimits
        quotes.each_with_index do |quote, index|
            link = quote.embeds[0]&.author&.url
            if link
                begin
                    link = link.split('/')
                    message_id = link.pop
                    channel_id = link.pop
                    message_channel = event.server.channels.select{|channel| channel.id == channel_id.to_i}
                    message_channel = message_channel.pop
                    unless message_channel.nil?
                        message = message_channel.load_message(message_id)
                        db.execute("INSERT INTO quotes VALUES (?,?,?,?)",
                            [ quote.embeds[0]&.author&.url, message.author.id.to_i, message.author.username, quote.content.split("#")[1].to_i ]
                        )
                    else
                        print("Deleted channel, ignoring")
                    end
                rescue Discordrb::Errors::UnknownMessage
                    print("Deleted message, ignoring")
                rescue SQLite3::ConstraintException
                    print("Duped message, ignoring")
                end
            end
            event.respond("#{((index.to_f/quotes.length) * 100).truncate(4)}% done") if index % 50 == 0
        end
        event.respond("All done.")
    else
        event.respond("Command disabled in this channel.")
    end
end

bot.command(:quotes) do |event, *filter|
    db = opendb
    quotes = []
    unless filter.empty?
        filter = filter.join(' ')
        filter_id = filter.split('!').last.to_i
        db.execute("SELECT * FROM quotes WHERE userid=#{filter_id} ORDER BY score DESC LIMIT 10") do |row|
            quotes.append({link: row[0], id: row[1], author: row[2], score: row[3]})
        end
    else
        db.execute("SELECT * FROM quotes ORDER BY score DESC LIMIT 10") do |row|
            quotes.append({link: row[0], id: row[1], author: row[2], score: row[3]})
        end
    end
    if quotes.length > 0
        description = "Top 10 quotes"
        description += " by #{filter}" unless filter.empty?
        description += "\n"
        quotes.first(10).each do |quote|
            description += "⭐**#{quote[:score]}**: #{quote[:link]} by **#{quote[:author]}**\n"
        end
        event.respond(description)
    else
        event.respond("Didn't find any quotes by the given user. You can input a ping or a userid to filter.")
    end
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
