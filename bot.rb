require "cinch"
require 'open-uri'
require 'nokogiri'
require 'cgi'
bot=Cinch::Bot.new do
  configure do |c|
    c.server = "chat.irc.tl"
    c.channels=["#NIKHIL"]
    c.nick="Imbot"
    c.port= 6669
end
# replies with bye
on :message, "!bye" do |m|
  m.reply "Bye, #{m.user}!"
end
# replies with hello
on :message, "!hello" do |m|
  m.reply "Hello, #{m.user}!"
end
#on join text
on :join do |m|
  unless m.user.nick==bot.nick
  m.reply "Welcome, #{m.user} to #{m.channel}, use !help for my commands."
end
end
#gives +v to user when they join
on :join do |m|
  unless m.user.nick == bot.nick
    m.channel.voice(m.user) if @autovoice
  end
end

on :channel, /^!autovoice (on|off)$/ do |m, option|
  @autovoice = option == "on"

  m.reply "Autovoice is now #{@autovoice ? 'enabled' : 'disabled'}"
end

# private msg to an user
on :message, /^!msg (.+?) (.+)/ do |m, who, text|
  User(who).send text
end
# urban dict

  helpers do
    def urban_dict(query)
      url = "http://www.urbandictionary.com/define.php?term=#{CGI.escape(query)}"
      CGI.unescape_html Nokogiri::HTML(open(url)).css("div.meaning").first.text.gsub(/\s+/, ' ').strip rescue nil
    end
  end

  on :message, /^!urban (.+)/ do |m, term|
    m.reply(urban_dict(term) || "No results found", true)
  end
  #coin flip

  on :message, /^!coinflip/ do |m|
    if( (rand (1..2))==1)
      a="Tails"
    else
       a="Heads"
    end
    m.reply "Its #{a}"
  end
  # dice roll
  on:message, /^!rolldice/ do |m|
    m.reply (rand(1..6))
  end
  #help commands
  on:message, /^!help/ do |m|
    m.reply "My commands : !rolldice, !coinflip, !urban query, !msg user text, !autovoice on/off, !hello, !bye"
  end
  on:leave do |m|
    m.reply "My Master Nikhil Terminated me :("
  end
end
bot.start
