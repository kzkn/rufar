module Rufar
  module Service
    class Web < Base
      def name
        Rufar.config.web_service_name || @app.defaults.web_service_name
      end

      def command
        choose_command(Rufar.config.web_command, %w[bin/rake app:server])
      end

      def register_new_task_definition(image_uri)
        @app.task_definitions.register(
          task_definition_family,
          image_uri,
          command,
          cpu: Rufar.config.web_cpu,
          memory: Rufar.config.web_memory,
          port_mappings: [{ container_port: 80, host_port: 80 }],
        )
      end

      def maximum_percent
        Rufar.config.web_deploy_maximum_percent || 200
      end

      def minimum_healthy_percent
        Rufar.config.web_deploy_minimum_healthy_percent || 50
      end

      def desired_count
        Rufar.config.web_desired_count || 1
      end

      def max_capacity
        Rufar.config.web_max_capacity || 20
      end

      def min_capacity
        Rufar.config.web_min_capacity || 1
      end

      def cpu_tracking_target_value
        Rufar.config.web_cpu_tracking_target_value || 60
      end

      def cpu_tracking_scale_in_cooldown
        Rufar.config.web_cpu_tracking_scale_in_cooldown || 60
      end

      def cpu_tracking_scale_out_cooldown
        Rufar.config.web_cpu_tracking_scale_out_cooldown || 30
      end

      def cpu_step_scaling_threshold
        Rufar.config.web_cpu_step_scaling_threshold || 70
      end

      def cpu_step_scaling_cooldown
        Rufar.config.web_cpu_step_scaling_cooldown || 30
      end

      def cpu_step_scaling_steps
        Rufar.config.web_cpu_step_scaling_steps || default_cpu_step_scaling_steps
      end

      def capacity_provider_strategy_mode
        Rufar.config.web_capacity_provider_strategy_mode || :hybrid
      end

      def custom_capacity_provider_strategies
        Rufar.config.web_custom_capacity_provider_strategies
      end

      def target_group_arn
        @app.load_balancer.target_group.arn
      end

      def service_params(task_definition)
        {
          cluster: @cluster.name,
          task_definition: task_definition.arn,
          desired_count:,
          capacity_provider_strategy: capacity_provider_strategies,
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
          load_balancers: [
            {
              target_group_arn:,
              container_name: task_definition.container_name,
              container_port: 80,
            },
          ],
        }
      end
    end
  end
end
