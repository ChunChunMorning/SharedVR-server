require 'socket'
require_relative './User'
require_relative './UserManager'

def set_port_number (argument, default_port)
	if argument.nil?
		return default_port
	end

	begin
		Integer argument
	rescue ArgumentError
		puts "Port number is invalid."
		exit -1
	end
end

def get_my_address
	TCPSocket.gethostbyname(Socket::gethostname)[4]
end



port = set_port_number ARGV[0], 1435
server = TCPServer.open port
user_manager = UserManager.new

puts "IP Address: #{get_my_address}."
puts "Listen on #{port}."

loop do
	user_manager.add_user server.accept
end
