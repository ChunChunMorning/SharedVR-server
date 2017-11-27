require 'socket'
require_relative './user'

class UserManager
	def initialize
		@users = Array.new
		@id = 0
		@mutex = Mutex.new

		Thread.new do
			loop do
				message = STDIN.gets

				puts 'Server,' + message
				send 'Server', message
			end
		end
	end

	def add_user socket
		@mutex.synchronize {
			send_unlocked 'Server', "add,#{@id}\n"

			message = "Server,you,#{@id}\n"
			@users.each { |user|
				message << "Server,add,#{user.id}\n"
			}

			socket.write message

			@users << User.new(self, @id, socket)

			@id += 1
		}
	end

	def erase_user user
		@mutex.synchronize {
			@users.delete user
			send_unlocked 'Sever', "erase,#{user.id}\n"
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
