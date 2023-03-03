require_relative "rore/app"
require_relative "rore/aws"
require_relative "rore/cli"
require_relative "rore/cluster"
require_relative "rore/config"
require_relative "rore/defaults"
require_relative "rore/deploy"
require_relative "rore/dsl"
require_relative "rore/load_balancer"
require_relative "rore/parameter_store"
require_relative "rore/roles"
require_relative "rore/service"
require_relative "rore/task"
require_relative "rore/task_definitions"
require_relative "rore/version"
require_relative "rore/vpc"

module Rore
  class Error < StandardError; end

  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield(config)
    end

    def logger
      config.logger
    end
  end
end
