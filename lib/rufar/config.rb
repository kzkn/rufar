require "logger"

module Rufar
  class Config
    CONFIGURATIONS = [
      # aws core
      :aws_region,
      :aws_credentials,
      # vpc
      :vpc_id,
      :subnets,
      :security_groups,
      # iam role
      :task_role_name,
      :execution_role_name,
      # parameter store
      :parameters_prefix,
      # load balancer
      :target_group_name,
      # task definition
      :container_name,
      :awslogs_group,
      :awslogs_region,
      # cluster
      :cluster_name,
      # web service
      :web_service_name,
      :web_desired_count,
      :web_command,
      :web_deploy_maximum_percent,
      :web_deploy_minimum_healthy_percent,
      :web_cpu,
      :web_memory,
      :web_max_capacity,
      :web_min_capacity,
      :web_cpu_tracking_target_value,
      :web_cpu_tracking_scale_in_cooldown,
      :web_cpu_tracking_scale_out_cooldown,
      :web_cpu_step_scaling_threshold,
      :web_cpu_step_scaling_cooldown,
      :web_cpu_step_scaling_steps,
      :web_capacity_provider_strategy_mode,
      :web_custom_capacity_provider_strategies,
      # worker service
      :worker_service_name,
      :worker_desired_count,
      :worker_command,
      :worker_deploy_maximum_percent,
      :worker_deploy_minimum_healthy_percent,
      :worker_cpu,
      :worker_memory,
      :worker_max_capacity,
      :worker_min_capacity,
      :worker_cpu_tracking_target_value,
      :worker_cpu_tracking_scale_in_cooldown,
      :worker_cpu_tracking_scale_out_cooldown,
      :worker_cpu_step_scaling_threshold,
      :worker_cpu_step_scaling_cooldown,
      :worker_cpu_step_scaling_steps,
      :worker_capacity_provider_strategy_mode,
      :worker_custom_capacity_provider_strategies,
      # deploy
      :app_release_task_definition_service_name,
      :app_release_command,
    ]

    attr_accessor :logger, :app_name, *CONFIGURATIONS

    def initialize
      @logger = Logger.new(STDOUT)
    end
  end
end
