require 'socket'
require_relative './user'

class UserManager
	def initialize
		@users = Array.new
		@names = [
			"ayeaye", "bear", "cat", "dog", "eagle",
			"fox", "goat", "hippo", "ibis", "jackal",
			"koala", "lion", "mouse", "newt", "owl", "pig",
			"quail", "rabbit", "sheep", "tiger", "unicon",
			"viper", "wolf", "xiwi", "yak", "zebla"
		]
		@names.shuffle!
		@mutex = Mutex.new
	end

	def add_user socket
		@mutex.synchronize {
			name = @names.shift
			@users << User.new(self, name, socket)
			puts "#{name} join!"
		}
	end

	def erase_user user
		@mutex.synchronize {
			name = user.name
			@names.push name
			@users.delete user
			puts "#{name} leave..."
		}
	end

	def send from, message
		@mutex.synchronize {
			@users.each { |user|
				if user.name != from
					user.write "#{from},#{message}"
				end
			}
			puts "#{from}: #{message}"
		}
	end
end
