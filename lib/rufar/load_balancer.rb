module Rufar
  class LoadBalancer
    Resource = Struct.new(:arn)

    def initialize(app)
      @app = app
    end

    def target_group
      @target_group ||= fetch_target_group
    end

    private

    def fetch_target_group
      name = Rufar.config.target_group_name || @app.defaults.target_group_name
      result = Aws.elb.describe_target_groups({ names: [name] })
      target_group = result.target_groups[0]
      Resource.new(target_group.target_group_arn)
    end
  end
end
