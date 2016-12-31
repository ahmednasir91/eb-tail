require 'net/ssh'
require 'aws-sdk'
require 'pp'
require 'colorize'
require 'yaml'
require 'optparse'
require 'ostruct'
require_relative 'eb-tail/environment'
require_relative 'eb-tail/server'

module EBTail

	class Main

		def init(args)
			Aws.use_bundled_cert! # Needed for windows platform, otherwise it gives an SSL error
			
			@servers = []
			@threads = []
			@credentials = {}
			@environments = {}

			begin
				options = apply_args! args

				if options.do_configure
					configure!
				else
					load_config!

					environment = get_environment(options.environment_name)

					environment.find_instances @credentials
					puts "Found instance(s) [#{environment.instances.join(', ')}]".green

					environment.tail!
				end

			rescue Interrupt
  				puts "STOPPING!".red
			rescue => err
				puts err.message.red
			end
		end

		def apply_args!(args)
			options = OpenStruct.new
			options.files = []
			options.do_configure = false

			p = OptionParser.new do |opts|
				opts.banner = "Usage: eb-tail [options] env-alias"

				opts.on('-f File', '--file File', "File to tail, specify complete path.") do |f|
					options.files = [f]
				end

				opts.on('-c', '--configure', "Configure environments") do
					options.do_configure = true
				end

				opts.on_tail("-h", "--help", "Show this message") do
			        puts opts
			        exit
			    end

			end
			p.parse args

			options.environment_name = args[0] if args.length > 0 && @environments.has_key?(args[0])

			options
		end

		def get_environment(env_name)
			raise "Environment name not specified, you have to pass it as argument to the program." if env_name.blank?
			raise "Environment name (#{args[0]}) not found in config file." if !@environments.has_key?(env_name)

			environment = @environments[env_name]

			environment.files = files if files.any?

			puts "Tail '#{environment.files.join(', ')}' on '#{environment.name}'".blue

			environment
		end

		def load_config!
			config_file_path = "#{File.dirname(__FILE__)}/config/config.yml"
			
			if File.exists?(config_file_path)
				puts "yes"
				@config = YAML.load_file(config_file_path)
			else
				raise "Config file is missing, run 'eb-tail --configure'"
			end

			validate_config
		end

		def validate_config
			raise "AWS credentials are missing, either add to the config.yml or environment vars." if !load_credentials!
			puts "Finding AWS credentials ... Done!".green

			raise "No Environments found in config.yml" if !load_environments!
			puts "Found environment(s) [#{@environments.keys.join(', ')}] in config file.".green


		end

		def load_credentials!
			@credentials[:access_key_id] = ENV['AWS_ACCESS_KEY_ID'] if ENV.has_key? 'AWS_ACCESS_KEY_ID'
			@credentials[:secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY'] if ENV.has_key? 'AWS_SECRET_ACCESS_KEY'
			@credentials[:region] = ENV['AWS_REGION'] if ENV.has_key? 'AWS_REGION'

			if @config.has_key? 'credentials'
				@credentials[:access_key_id] = @config['credentials']['aws_key'] if @config['credentials'].has_key? 'aws_key'
				@credentials[:secret_access_key] = @config['credentials']['aws_secret'] if @config['credentials'].has_key? 'aws_secret'
				@credentials[:region] = @config['credentials']['aws_region'] if @config['credentials'].has_key? 'aws_region'
			end

			@credentials.length == 3
		end

		def load_environments!
			@config['environments'].each do |env|
				@environments[env.has_key?('alias') ? env['alias'] : env['name']] = Environment.new(env)
			end

			@environments.length > 0
		end

		def configure!
			raise "This is still underconstruction, for now do it manually."
		end

	end
end