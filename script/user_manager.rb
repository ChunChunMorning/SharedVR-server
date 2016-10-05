require 'socket'
require_relative './user'

class UserManager
	def initialize
		@users = Array.new
		@id = 0
		@mutex = Mutex.new
	end

	def add_user socket
		@mutex.synchronize {
			send_unlocked @id, "add\n"

			posX = Math.cos(Math::PI / 2 * @id)
			posZ = Math.sin(Math::PI / 2 * @id)

			message = "#{@id},you,#{posX},0,#{posZ}\n"
			@users.each { |user|
				message << "#{user.id},add,#{user.position}\n"
			}

			socket.write message

			@users << User.new(self, @id, socket)

			@id += 1
		}
	end

	def erase_user user
		@mutex.synchronize {
			@users.delete user
			send_unlocked user.id, "erase\n"
		}
	end

	def send from, message
		@mutex.synchronize {
			send_unlocked from, message
		}
	end

	def send_unlocked from, message
		@users.each { |user|
			if user.id != from
				user.write "#{from},#{message}"
			end
		}
		puts "#{from}: #{message}"
	end
end
