require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing..."
		@client = JumpstartAuth.twitter
	end
	
	def tweet(message)
		if message.length > 140
			puts "Sua mensagem é muito longa"
		else
			@client.update(message)
			puts "Done"
		end
	end

end

blogger = MicroBlogger.new
blogger.tweet("1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890
	1234567890 1234567890")	