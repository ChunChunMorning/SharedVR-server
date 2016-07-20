require 'socket'
#require_relative './UserManager'

class User
	def initialize name, socket
		@name = name
		@socket = socket
		@read_thread = Thread.new {
			while @socket.gets
				if $_ == "quit\n"
					break;
				else
					@socket.write @name + ',' + $_
					write @name + ',' + $_
				end
			end
		}
	end

	def name
		@name
	end

	def write message
		puts message
	end
end
