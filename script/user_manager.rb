require 'socket'
require_relative './user'

class UserManager
	def initialize
		@users = Array.new
		@names = [
			"ant", "bear", "cat", "dog", "eel",
			"fox", "goat", "hippo", "jackal", "koala",
			"lion", "mouse", "newt", "owl", "pig",
			"quail", "rabbit", "sheep", "tiger", "unicon",
			"viper", "wolf", "xyz", "yak", "zebla"
		]
		@names.shuffle!
	end

	def add_user socket
		mutex = Mutex.new

		mutex.synchronize {
			name = @names.shift
			@users << User.new(self, name, socket)
			puts "#{name} join!"
		}
	end

	def send from, message
		mutex = Mutex.new

		mutex.synchronize {
			@users.each { |user|
				if user.name != from
					user.write "#{from},#{message}"
				end
			}
			puts "#{from}: #{message}"
		}
	end
end
