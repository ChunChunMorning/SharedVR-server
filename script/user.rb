require 'socket'
require 'timeout'
require_relative './user_manager'

class User
	def initialize user_manager, name, socket
		@user_manager = user_manager
		@name = name
		@socket = socket
		@read_thread = Thread.new {
			loop {
				begin
					Timeout.timeout(60) {
						@socket.gets

						if $_ == "quit\n"
							break;
						else
							@user_manager.send @name, $_
						end
					}
				rescue Timeout::Error
					break
				end
			}
			@socket.close
			@user_manager.erase_user self
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
