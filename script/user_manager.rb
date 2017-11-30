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
					indexes = Array((0 ... 9)).shuffle
					ids = [0, 0, 0, 1, 1, 1, 2, 2, 2].shuffle

					message.gsub! /shuffle/, "shuffle,#{indexes.join},#{ids.join[0, 10]}"
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
