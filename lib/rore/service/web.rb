module Rore
  module Service
    class Web < Base
      def task_definition_params(image_uri)
        {
          cpu:,
          memory:,
          family: task_definition_name,
          execution_role_arn:,
          requires_compatibilities: ["FARGATE"],
          network_mode: "awsvpc",
          container_definitions: [{
            name: task_definition_name,
            image: image_uri,
            secrets:,
            port_mappings: [
              {
                container_port: 80,
                host_port: 80,
              },
            ],
            log_configuration:,
          }],
        }
      end

      def create_service_params(task_def_arn)
        {
          cluster: cluster_name,
          service_name:,
          task_definition: task_def_arn,
          desired_count: 1,
          launch_type: "FARGATE",
          deployment_configuration: {
            maximum_percent: 200,
            minimum_healthy_percent: 50,
          },
          network_configuration: {
            awsvpc_configuration: {
              subnets: subnet_ids,
              security_groups: [],
              assign_public_ip: "ENABLED",
            },
          },
        # TODO: load_balancers
        }
      end
    end
  end
end
