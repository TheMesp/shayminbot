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

bot.message(contains: '??') do |event|
	event.respond 'love sosa?? cheif keef???'
end

bot.command(:kid, description: 'Post a wacky image from a cracked kid', usage: 's!kid') do |event|
	names = []
	d = Dir.new("/usr/crackedkids")
	d.each_child do |filename|
		names << filename
	end
	img = File.new("/usr/crackedkids/#{names.sample}")
	bot.send_file(event.message.channel.id, img)
end

bot.command(:mfa, description: 'Wisdom from the man himself', usage: 's!mfa') do |event|
	quotes = %w(
		Hmm...\ Balls
		All\ rock\ stars\ are\ facinated\ with\ poop,\ pee,\ and\ are\ gay
		RIP\ Marblelympics...\ We\ shall\ miss\ the\ glory\ days.
		make\ the\ area\ 51\ raid\ room\ into\ a\ private\ channel,\ so\ that\ the\ sensible\ ones\ who\ are\ not\ going\ will\ not\ be\ affected\ by\ the\ brainwashing.
		who\ has\ camp\ next\ week?\ :white_check_mark:\ if\ yes\ :x:\ if\ no.
		+s\ rename\ #suggestion-submit\ to\ plead\ to\ the\ modocracy\ dont\ delete\ this\ Gliding\ Glaciers\ UwU
		What\ is\ the\ fetish\ with\ the\ Balls\ of\ Flame?
		ok\ so\ I\ think\ these\ card\ are\ rigged.\ Because\ people\ who\ talk\ do\ not\ get\ cards\ but\ people\ who\ just\ type\ one\ word...\ get\ the\ cards.
		https://cdn.discordapp.com/attachments/658508426858463234/729892650961862676/video0.mov
		https://tenor.com/view/palla-deserto-gif-6014273
	)
	event.respond quotes.sample
end

bot.command(:hornets, description: 'You know it', usage: 's!hornets') do |event|
	event.respond "FUCK THE HORNETS"
end

bot.command(:echo, description: 'Have shaymin say whatever you say', usage: 's!echo <text to be repeated>') do |event, *text|
	text = text.join(" ").gsub('@','')
	log_action(bot, event)
    event.respond text
    event.message.delete
end

bot.command(:insult, description: 'Generate a spicy insult', usage: 's!insult <victim>') do |event, *victim|
    first_word = %w(
		DISGRUDING
		DEROGATORY
        FUCKING
        SHIT\ EATING
        ARBITRARY
        GREEDY
        LAZY
        ATROCIOUS
        DREADFUL
        AWFUL
        PUNY
        MISERABLE
        POLYGONAL
        LOW\ RESOLUTION
        REVOLTING
        REPULSIVE
        DISGUSTING
        EYE\ MELTING
		OBTUSE
		INSECURE
    )
    second_word = %w(
        FUCK
        SHIT
        DICK
        JERK
        BULLY
        ASS
        DANK
        IMPISH
        DEVIL'S
        DEMON'S
        MOCKERY\ OF\ A
        BARELY\ QUALIFIED
        SHITSHOW\ OF\ A
    )
    third_word = %w(
        TOASTER
        CANOE
        SHOE
        BOOT
        THING
        HAMMER
        GOBLIN
        HOBGOBLIN
        GOBHOBLIN
        ORC
        IMP
        KOBOLD
        CREATURE
        MONSTER
        HERB
    )
    event.respond "#{victim.join(" ").gsub('@','')} you are a #{first_word.sample} #{second_word.sample} #{third_word.sample}\n
    (Please don't use this against real people without consent! Use s!praise if you need something kinder)"
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
