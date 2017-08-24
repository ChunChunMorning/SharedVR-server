require 'socket'

module Port
	def set_port_number argument, default_port
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
		# http://qiita.com/saltheads/items/cc49fcf2af37cb277c4f
		udp = UDPSocket.new
		udp.connect("128.0.0.0", 7)
		adrs = Socket.unpack_sockaddr_in(udp.getsockname)[1]
		udp.close
		adrs
	end

	module_function :set_port_number
	module_function :get_my_address
end
