module EBTail
	class Server 

		def initialize(host, user, key, color)
			session_options = { }
	        session_options[:keys] = key
	        session_options[:port] = 22
	        @channels = []
	        @host = host
	        @user = user
	        @color = color

			begin
				puts "Connecting to #{host}...".blue
				@session = Net::SSH.start(host, user, session_options)
				puts "Connected to #{host}".green
			rescue SocketError, Errno::ECONNREFUSED => e
				puts "!!! Could not connect to #{host}. Check to make sure that this is the correct url.".red
				puts $!
				exit
			rescue Net::SSH::AuthenticationFailed => e
				puts "!!! Could not authenticate on #{host}. Make sure you have set the username and password correctly. Or if you are using SSH keys make sure you have not set a password.".red
				puts $!
				exit
			end
		end

		def tail(files)
			do_tail(files.join(' -100f '), "tail -100f ")
			@session.process(0)
		end

		def parse_line(data)
			@buffer.split("\n").each() do |line|
				puts "#{@host}[#{@user}]: #{line}".colorize(@color)
			end

			@buffer = "" if @buffer.include? "\n"
		end

		def do_tail( file, command )
			puts "Tailing...".blue
			@session.open_channel do |channel|
				puts "Channel opened on #{@session.host}...".green

				@buffer = ""

				channel.on_data do |ch, data|
					@buffer << data
					parse_line(data)
				end

				channel.on_open_failed do |ch|
					ch.close
				end

				channel.on_extended_data do |ch, data|
					puts "STDERR: #{data}".red
				end

				channel.on_close do |ch|
					ch[:closed] = true
				end

				puts "Running command #{command} #{file}"

				channel.exec "#{command} #{file}  "

				puts "Pushing #{@session.host}".blue
				@channels.push(channel)
			end

			@session.loop
		end
	end
end