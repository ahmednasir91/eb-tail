module EBTail
	class Environment 

		attr_accessor :files
		attr_reader :name, :instances

		def initialize(h)
			raise "Environment name is not specified." if !h.has_key?('name')
			@name = h['name']

			@files = h.has_key?('files') ? h['files'] : []

			@user = h.has_key?('user') ? h['user'] : 'ec-user'

			raise "Key is not defined for environment." if !h.has_key?('key')
			@key = h['key']
			
			@use_private_ip = h.has_key?('use_private_ip') ? h['use_private_ip'] : false
		end

		def find_instances(cred)
			@instances = []

			puts "Finding instances ...".blue

			client = Aws::EC2::Client.new cred
			resp = client.describe_instances({
				filters: [
					{
						name: "tag-value",
						values: [@name],
					},
				],
			})

			resp.reservations.each do |r|
				r.instances.each do |i| 
					@instances << (@use_private_ip ? i.private_ip_address : i.public_ip_address)
				end
			end

		end

		def tail! 
			colors = [:blue, :gray, :magenta, :cyan]
			threads = []

			@instances.each do |i|
				threads << Thread.new {
					col = colors[Random.rand(0..(colors.length - 1))]
					server = Server.new(i, @user, @key, col)	
					server.tail @files
				}
			end

			threads.each do |t| 
				t.join
			end
		end
	end
end