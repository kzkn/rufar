module Rore
  class EnvVar
    attr_reader :name, :arn

    def initialize(name, arn)
      @name = name
      @arn = arn
    end

    class << self
      def retrieve(app_name, cluster_name)
        prefix = "/#{app_name}/#{cluster_name}"
        result = Aws.ssm.get_parameters_by_path({ path: prefix, recursive: true })
        result.parameters.map { |p| from_parameter(p) }
      end

      def from_parameter(parameter)
        var_name = parameter.name.split("/")[-1]
        new(var_name, parameter.arn)
      end
    end
  end
end
