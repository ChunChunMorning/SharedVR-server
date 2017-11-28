require 'date'

class Log
	def self.create
		now = DateTime.now

		@@time = now.strftime('%m-%d-%S-%H-%M-%L')
		@@text = "#{now}\n-------------------------\n\n"
	end

	def self.save
		File.open("log/#{@@time}.txt",'w') do |file|
			file.puts @@text
		end
	end

	def self.write message
		@@text += "#{Time.now.strftime('[%H:%M:%L]')} #{message}"
	end

	def self.filename
		"#{@@time}.txt"
	end
end
