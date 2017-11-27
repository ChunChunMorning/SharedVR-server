require 'socket'
require 'timeout'
require_relative './user_manager'

class User

	def initialize user_manager, id, socket
		@user_manager = user_manager
		@id = id
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
	end

	def id
		@id
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
		begin
			@socket.write message
		rescue
			puts "Error: #{@id} can't receive."
		end
	end

	def analyze message
		case message
		when "\n"
			# Reset timeout.
		else
			@user_manager.send @id, message
		end
	end
end
