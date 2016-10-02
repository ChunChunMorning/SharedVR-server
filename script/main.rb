require 'socket'
require_relative './port/port'
require_relative './user'
require_relative './user_manager'

port = Port.set_port_number ARGV[0], 1435
server = TCPServer.open port
user_manager = UserManager.new

puts "\n-------------------------"
puts "IP Address: #{Port.get_my_address}."
puts "Listen on #{port}."
puts "-------------------------"

loop do
	user_manager.add_user server.accept
end
