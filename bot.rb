require 'cinch'

class Bot
  
  COMMANDS = {}

bot = Cinch::Bot.new do
    configure do |c|
    c.server = "irc.quakenet.org" 
    c.nick     = "Botio"
    c.channels = ["#ad09"]
  end

  on :message, "hello" do | m |
    m.reply "Hello, #{m.user.nick}"
  end
  
  on :message, "what's up" do | m |
    m.reply "Nothing whats up with you?!"
  end
  
  on :message, /\?/ do |m|
  		unless @users.key? m.user.nick.to_sym
  			m.channel.send "#{m.user.nick}: Thanks for asking a question! You can also get help here: http://timromberg.se"
  			seen = Seen.new(m.user.nick)
  			seen.save
  			@users[m.user.nick.to_sym] = true
  		end
  		qr = Question.new(m.user.nick, m.message, Time.new)
  		qr.save
  		m.channel.send "#{m.user.nick}: your question has been recorded."
   end
  
  on :channel, /^!question (.+)/ do |m, nick|
   		if nick == bot.nick
   			m.reply "That's me!"
   		elsif @users.key?(nick.to_sym)
   			m.reply "The last 5 questions by #{nick} are:"
   			Question.find_for_nick(nick).each do |qr|
   				m.reply qr.to_s
   			end
   			m.reply "That's all!"
   		else
   			m.reply "I haven't seen #{nick}"
   		end
   	end
   	
   	on :message, "quit" do | m |
       bot.quit
     end
   end 
   
bot.start
end
