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
    text = text.join(" ").gsub('@','')
    event.respond text
    event.message.delete
end

bot.command(:insult) do |event, *victim|
    first_word = %w(
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
        friend\ :\)
    )
    event.respond "#{victim.join(" ")} you are a #{first_word.sample} #{second_word.sample} #{third_word.sample}\n
    (Please don't take these seriously! Use s!praise if you need something kinder)"
end

bot.command(:praise) do |event, *victim|
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
    event.respond "#{victim.join(" ")} you are a #{first_word.sample} #{second_word.sample} #{third_word.sample}"
end

# initial setup
bot.run(true)
puts 'bot active'
bot.join
