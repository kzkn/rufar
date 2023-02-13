module Rore
  module Service
    class Base
      # TODO: remove execution_role_arn
      attr_accessor :execution_role_arn, :service_arn

      def initialize(cluster)
        @cluster = cluster
        @task_def_arn = nil
      end

      def cluster_name
        @cluster.cluster_name
      end

      def subnet_ids
        @cluster.subnets.map(&:subnet_id)
      end

      def service_name
        self.class.name.split("::")[-1].downcase
      end

      def task_definition_name
        "#{cluster_name}_#{service_name}"
      end

      def create_or_update_service(task_def_arn)
        unless create_service(task_def_arn)
          update_service(task_def_arn)
        end
      end

      def create_service(task_def_arn)
        return if exists_service?

        result = Aws.ecs.create_service(create_service_params(task_def_arn))
        @service_arn = result.service.service_arn
      end

      def update_service(task_def_arn)
        Aws.ecs.update_service({
                                 cluster: cluster_name,
                                 service: @service_arn,
                                 task_definition: task_def_arn,
                               })
      end

      def exists_service?
        fetch_service
        !!@service_arn
      end

      def fetch_service
        result = Aws.ecs.describe_services({
                                             cluster: cluster_name,
                                             services: [service_name],
                                           })
        service = result.services.find { |s| s.service_name == service_name && s.status == "ACTIVE" }
        @service_arn = service&.service_arn
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
            "awslogs-group" => cluster_name,
            "awslogs-region" => Rore.config.aws_region,
            "awslogs-stream-prefix" => service_name,
          },
        }
      end
    end
  end
end
