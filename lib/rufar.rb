require_relative "rufar/app"
require_relative "rufar/aws"
require_relative "rufar/cli"
require_relative "rufar/cluster"
require_relative "rufar/config"
require_relative "rufar/defaults"
require_relative "rufar/deploy"
require_relative "rufar/load_balancer"
require_relative "rufar/parameter_store"
require_relative "rufar/roles"
require_relative "rufar/service"
require_relative "rufar/task"
require_relative "rufar/task_definitions"
require_relative "rufar/version"
require_relative "rufar/vpc"

module Rufar
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
