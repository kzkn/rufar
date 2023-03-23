require "optparse"

module Rufar
  class CLI
    EXIT_SUCCESS = 0
    EXIT_FAILURE = 1

    def initialize(argv)
      @subcommand = read_sub_command(argv)
      @options = {}
      option_parsers[@subcommand].order!(argv, into: @options)
      @rest_args = argv
    end

    def read_sub_command(argv)
      cmd = argv.shift
      return cmd if option_parsers.key?(cmd)

      subcommands = option_parsers.keys
      STDERR.puts "Usage: rufar #{subcommands.join(" | ")}"
      exit EXIT_FAILURE
    end

    def option_parsers
      @options_parsers ||= {
        "deploy" => OptionParser.new do |opts|
          opts.banner = "Usage: rufar deploy [options] APP_NAME IMAGE_URI"
          opts.on("-C PATH", "--config PATH", "Load PATH as a config file")
        end,
      }
    end

    def run
      status_code = case @subcommand
        when "deploy"
          app_name, image_uri = @rest_args
          deploy(app_name, image_uri)
        else
          EXIT_FAILURE
        end
      exit status_code
    end

    def deploy(app_name, image_uri)
      return help_for_subcommand unless app_name && image_uri

      if @options[:config]
        Rufar.config.load_file(@options[:config])
      end
      app = App.new(app_name)

      Rufar.logger.info "Start deploy #{app.name}"
      deploy = Deploy.new(app)
      deploy.run(image_uri)

      Rufar.logger.info "Finish deploy #{app.name}"
      EXIT_SUCCESS
    end

    def help_for_subcommand
      STDERR.puts option_parsers[@subcommand].help
      EXIT_FAILURE
    end

    class << self
      def run(argv)
        new(argv).run
      end
    end
  end
end
