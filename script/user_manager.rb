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
			@users << User.new(self, @id.to_s, socket)
			puts "#{@id} join!"
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
			@users.each { |user|
				if user.id != from
					user.write "#{from},#{message}"
				end
			}
			puts "#{from}: #{message}"
		}
	end
end
