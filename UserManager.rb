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
		@users = Array.new
	end

	def add_user socket
		@users << User.new((@@names.sample 1), socket)
	end

end
