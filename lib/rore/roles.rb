module Rore
  class Roles
    Role = Struct.new(:arn)

    def initialize(app)
      @app = app
    end

    def task_role
      role_name = Rore.config.task_role_name || @app.defaults.task_role_name
      @task_role ||= fetch_role(role_name)
    end

    def execution_role
      role_name = Rore.config.execution_role_name || @app.defaults.execution_role_name
      @execution_role ||= fetch_role(role_name)
    end

    private

    def fetch_role(role_name)
      result = Aws.iam.get_role({ role_name: })
      Role.new(result.role.arn)
    end
  end
end
