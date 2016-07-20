require 'socket'

class User
	def initialize(socket)
		@socket = socket;

		@read_thread = Thread.new {
			while @socket.gets
				if $_ == "quit\n"
					break;
				else
					@socket.write $_
					write $_
				end
			end
		}
	end

	def write message
		puts message
	end
end
