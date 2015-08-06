require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing..."
		@client = JumpstartAuth.twitter
	end
	
	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
				when 'q' then puts "Goodbye!"
				when 't' then tweet(parts[1..-1].join(" "))
				when 'dm' then dm(parts[1], parts[2..-1].join(" "))
				when 'spam' then spam_my_followers(parts[1..-1].join(" "))
				when 'elt' then everyones_last_tweet
			else
				puts "Sorry, I don't know how to #{command}"
			end
		end
	end

	def tweet(message)
		if message.length > 140
			puts "Sua mensagem é muito longa"
		else
			@client.update(message)
			puts "Done"
		end
	end

	def followers_list
		screen_names = []
		@client.followers.each { |follower| screen_names << @client.user(follower).screen_name }
		screen_names
	end

	def dm(target, message)
		puts "Trying to send #{target} this direct message:"
		puts message
		if followers_list.include?(target)
			message = "d @#{target} #{message}"
			tweet(message)
		else
			puts "you can only DM people who follow you"
		end
	end

	def spam_my_followers(message)
		puts "Spam all your followers with this direct message:"
		puts message
		followers_list.each do |follower|
			dmessage = "d @#{follower} #{message}"
			tweet(dmessage)
		end
	end

	def everyones_last_tweet
		friends = @client.friends
    friends = friends.map { |friend| @client.user(friend) }
    friends.sort_by! { |friend| friend.screen_name.downcase}
   
    friends.each do |friend|
      timestamp = friend.status.created_at.strftime('%A, %b %d')
      tweet = friend.status.text
      puts "@#{friend.screen_name} said..."
      printf "#{tweet} at #{timestamp}"
      puts ''
    end
	end

end

blogger = MicroBlogger.new
blogger.run