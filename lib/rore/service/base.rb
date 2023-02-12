module Rore
  module Service
    class Base
      attr_accessor :execution_role_arn

      def initialize(cluster)
        @cluster = cluster
        @task_def_arn = nil
      end

      def service_name
        self.class.name.split("::")[-1].downcase
      end

      def task_definition_name
        "#{@cluster.cluster_name}_#{service_name}"
      end

      def register_task_definition(image_uri)
        result = Aws.ecs.register_task_definition(task_definition_params(image_uri))
        @task_def_arn = result.task_definition.task_definition_arn
      end

      def task_definition_params(image_uri)
        raise NotImplementedError
      end

      def secrets
        env_vars = @cluster.retrieve_env_vars
        env_vars.map { |e| { name: e.name, value_from: e.arn } }
      end

      def cpu
        "256"
      end

      def memory
        "512"
      end

      def log_configuration
        {
          log_driver: "awslogs",
          options: {
            "awslogs-group" => @cluster.cluster_name,
            "awslogs-region" => Rore.config.aws_region,
            "awslogs-stream-prefix" => service_name,
          },
        }
      end
    end
  end
end
