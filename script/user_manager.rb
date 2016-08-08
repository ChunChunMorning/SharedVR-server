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
			send_unlocked 's', "add,#{@id}"
			@users << User.new(self, @id.to_s, socket)

			data = "you,#{@id}\n"
			@users.each { |user|
				data << "add,#{user.id},#{user.position}\n"
			}
			socket.write data

			@id += 1
		}
	end

	def erase_user user
		@mutex.synchronize {
			@users.delete user
			puts "#{user.id} leave..."
		}
	end

	def send from, message
		@mutex.synchronize {
			send_unlocked from message
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
