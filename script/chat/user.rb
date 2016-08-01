require 'socket'
require 'timeout'
require_relative './user_manager'

module Chat
	class User
		def initialize user_manager, name, socket
			@user_manager = user_manager
			@name = name
			@socket = socket
			Thread.new {
				loop {
					message = read

					if message.nil?
						break
					else
						analyze message
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

		def read
			begin
				Timeout.timeout(60) {
					@socket.gets
				}
				$_ == "quit\n" ? nil : $_
			rescue Timeout::Error
				nil
			end
		end

		def write message
			@socket.write message
		end

		def analyze message
			case message
			when "\n"
				# Reset timeout.
			else
				@user_manager.send @name, message
			end
		end
	end
end
