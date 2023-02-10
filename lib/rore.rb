require_relative "rore/aws"
require_relative "rore/app"
require_relative "rore/cluster"
require_relative "rore/config"
require_relative "rore/env_var"
require_relative "rore/version"

module Rore
  class Error < StandardError; end

  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield(config)
    end
  end
end
