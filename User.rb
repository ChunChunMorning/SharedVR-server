require 'socket'
require_relative './UserManager'

class User
	def initialize user_manager, name, socket
		@user_manager = user_manager
		@name = name
		@socket = socket
		@read_thread = Thread.new {
			while @socket.gets
				if $_ == "quit\n"
					break;
				else
					@user_manager.send @name, $_
				end
			end
		}

		@socket.write "server,You are #{@name}"
	end

	def name
		@name
	end

	def write message
		@socket.write message
	end
end
