module Rore
  class EnvVar
    def initialize(name, arn)
      @name = name
      @arn = arn
    end

    class << self
      def retrieve(service_name, env_name)
        prefix = "/#{service_name}/#{env_name}"
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
