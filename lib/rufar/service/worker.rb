module Rufar
  module Service
    class Worker < Base
      def name
        Rufar.config.worker_service_name || @app.defaults.worker_service_name
      end

      def command
        choose_command(Rufar.config.worker_command, %w[bin/rake app:worker])
      end

      def register_new_task_definition(image_uri)
        @app.task_definitions.register(
          task_definition_family,
          image_uri,
          command,
          cpu: Rufar.config.worker_cpu,
          memory: Rufar.config.worker_memory,
        )
      end

      def maximum_percent
        Rufar.config.worker_deploy_maximum_percent || 200
      end

      def minimum_healthy_percent
        Rufar.config.worker_deploy_minimum_healthy_percent || 50
      end

      def desired_count
        Rufar.config.worker_desired_count || 1
      end

      def service_params(task_definition)
        {
          cluster: @cluster.name,
          service_name: name,
          task_definition: task_definition.arn,
          desired_count:,
          launch_type: "FARGATE",
          deployment_configuration: {
            maximum_percent:,
            minimum_healthy_percent:,
          },
          network_configuration: {
            awsvpc_configuration: {
              subnets:,
              security_groups:,
              assign_public_ip: "ENABLED",
            },
          },
        }
      end
    end
  end
end
