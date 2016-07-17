require 'socket'

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

puts "IP Address: #{get_my_address}."
puts "Listen on #{port}."

socket = server.accept

puts "#{socket} is accepted."

while socket.gets
	puts $_
	socket.write $_
end

puts "#{socket} is gone."
