require 'socket'
require_relative './log'
require_relative './port/port'
require_relative './user'
require_relative './user_manager'

port = Port.set_port_number ARGV[0], 1435

puts "\n-------------------------"
puts Time.now
puts "IP Address: #{Port.get_my_address}."
puts "Listen on #{port}."
puts "-------------------------"

server = TCPServer.open port
user_manager = UserManager.new

begin
	Log.create

	loop do
		user_manager.add_user server.accept
	end
rescue Interrupt
	Log.save

	puts "\nSave as #{Log.filename}."
end
