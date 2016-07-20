require 'socket'
require_relative './User'

class UserManager
	@@names = [
		"ant", "bear", "cat", "dog", "eel",
		"fox", "goat", "hippo", "jackal", "koala",
		"lion", "mouse", "newt", "owl", "pig",
		"quail", "rabbit", "sheep", "tiger", "unicon",
		"viper", "wolf", "xyz", "yak", "zebla"
	]

	def initialize
		@users = {}
	end

	def add_user socket
		loop do
			name = @@names.sample 1
			if !exist_user? name
				break
			end
		end

		@users << User.new(name, socket)
	end

	def exist_user? name
		@users.each { |user|
			if name == user.name
				return true
			end
		}
		false
	end

end
