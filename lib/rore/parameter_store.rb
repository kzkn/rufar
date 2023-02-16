module Rore
  class ParameterStore
    Parameter = Struct.new(:name, :arn)

    def initialize(app)
      @app = app
    end

    def parameters
      @parameters ||= fetch_parameters
    end

    private

    def parameters_prefix
      Rore.config.parameters_prefix || @app.defaults.parameters_prefix
    end

    def fetch_parameters
      result = Aws.ssm.get_parameters_by_path({ path: parameters_prefix, recursive: true })
      result.parameters.map { |p| from_parameter(p) }
    end

    def from_parameter(parameter)
      var_name = parameter.name.split("/")[-1]
      Parameter.new(var_name, parameter.arn)
    end
  end
end
