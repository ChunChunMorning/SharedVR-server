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



port = set_port_number ARGV[0], 1435

puts port
