require 'cinch'
File.join(File.dirname(__FILE__), 'google.rb')
class Bot
  
  COMMANDS = {}

bot = Cinch::Bot.new do
    configure do |c|
    c.server = "irc.freenode.net" 
    c.nick     = "Botio"
    c.reconnect = true
    c.channels = ["#cinters"]
    c.password = "access"
    c.port = "6667"
  end


def identify_nickserv
  User("nickserv").send("identify %s %s" % [config[:username], config[:password]])
end


  on :message, "hello" do | m |
    m.reply "Hello, #{m.user.nick}"
  end
  
  on :message, "what's up?" do | m |
    m.reply "Nothing whats up with you?!"
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
