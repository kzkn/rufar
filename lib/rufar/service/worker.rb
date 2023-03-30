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

      def max_capacity
        Rufar.config.worker_max_capacity || 20
      end

      def min_capacity
        Rufar.config.worker_min_capacity || 1
      end

      def cpu_tracking_target_value
        Rufar.config.worker_cpu_tracking_target_value || 60
      end

      def cpu_tracking_scale_in_cooldown
        Rufar.config.worker_cpu_tracking_scale_in_cooldown || 60
      end

      def cpu_tracking_scale_out_cooldown
        Rufar.config.worker_cpu_tracking_scale_out_cooldown || 30
      end

      def cpu_step_scaling_threshold
        Rufar.config.worker_cpu_step_scaling_threshold || 70
      end

      def cpu_step_scaling_cooldown
        Rufar.config.worker_cpu_step_scaling_cooldown || 30
      end

      def cpu_step_scaling_steps
        Rufar.config.worker_cpu_step_scaling_steps || default_cpu_step_scaling_steps
      end

      def capacity_provider_strategy_mode
        Rufar.config.worker_capacity_provider_strategy_mode || :hybrid
      end

      def custom_capacity_provider_strategies
        Rufar.config.worker_custom_capacity_provider_strategies
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
        }
      end
    end
  end
end
