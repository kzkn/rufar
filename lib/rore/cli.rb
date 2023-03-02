module Rore
  class CLI
    EXIT_SUCCESS = 0
    EXIT_FAILURE = 1

    def initialize(argv)
      @argv = argv
    end

    def run
      status_code = case @argv[0]
        when "deploy"
          app_name, image_uri = @argv[1], @argv[2]
          deploy(app_name, image_uri)
        else
          help
        end
      exit status_code
    end

    def deploy(app_name, image_uri)
      return help unless app_name && image_uri

      app = App.new(app_name)
      deploy = Deploy.new(app)
      deploy.run(image_uri)
      EXIT_SUCCESS
    end

    def help
      STDERR.puts "Usage: rore deploy APP_NAME IMAGE_URI"
      EXIT_FAILURE
    end

    class << self
      def run(argv)
        new(argv).run
      end
    end
  end
end
