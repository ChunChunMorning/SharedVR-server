require 'socket'
require 'time'
require_relative './log'
require_relative './user'

class UserManager
	def initialize
		@users = Array.new
		@id = 0
		@mutex = Mutex.new

		Thread.new do
			loop do
				message = STDIN.gets

				if message == "shuffle\n"
					message.gsub! /shuffle/, "shuffle,#{Array((0 ... 10)).shuffle.join}"
				end

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

			puts "User #{@id} join."

			@id += 1
		}
	end

	def erase_user user
		@mutex.synchronize {
			@users.delete user
			send_unlocked 'Server', "erase,#{user.id}\n"

			puts "User #{user.id} left."
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

		Log.write "#{from}: #{message}"
	end
end
