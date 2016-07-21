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
		TCPSocket.gethostbyname(Socket::gethostname)[4]
	end

	module_function :set_port_number
	module_function :get_my_address
end
