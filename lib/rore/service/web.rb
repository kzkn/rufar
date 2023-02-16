module Rore
  module Service
    class Web < Base
      def name
        Rore.config.web_service_name || @app.defaults.web_service_name
      end

      def command
        Rore.config.web_command || %w[bin/rake app:server]
      end

      def register_new_task_definition(image_uri)
        @app.task_definitions.register(
          task_definition_family,
          image_uri,
          command,
          port_mappings: [{ container_port: 80, host_port: 80 }],
        )
      end

      def maximum_percent
        Rore.config.web_deploy_maximum_percent || 200
      end

      def minimum_healthy_percent
        Rore.config.web_deploy_minimum_healthy_percent || 50
      end

      def desired_count
        Rore.config.web_desired_count || 1
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
        # TODO: load_balancers
        }
      end
    end
  end
end
