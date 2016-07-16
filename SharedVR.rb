port = 1435;

if !ARGV[0].nil?
	begin
		port = Integer ARGV[0]
	rescue ArgumentError
		puts "Port number is invalid."
		exit -1
	end
end

puts port
