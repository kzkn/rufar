module Rufar
  module Service
    class AutoScaling
      def initialize(service)
        @service = service
      end

      def update_policies
        register_scalable_target
        cpu_based_target_tracking_scaling_policy
        cpu_based_step_scaling_policy
      end

      private

      def register_scalable_target
        Aws.app_autoscaling.register_scalable_target({
          max_capacity: @service.max_capacity,
          min_capacity: @service.min_capacity,
          resource_id:,
          scalable_dimension: "ecs:service:DesiredCount",
          service_namespace: "ecs",
        })
      end

      def cpu_based_target_tracking_scaling_policy
        Aws.app_autoscaling.put_scaling_policy({
          policy_name: "#{policy_prefix}-cpu-target-tracking-scaling-policy",
          policy_type: "TargetTrackingScaling",
          resource_id:,
          scalable_dimension: "ecs:service:DesiredCount",
          service_namespace: "ecs",
          target_tracking_scaling_policy_configuration: {
            predefined_metric_specification: {
              predefined_metric_type: "ECSServiceAverageCPUUtilization",
            },
            scale_in_cooldown: @service.cpu_tracking_scale_in_cooldown,
            scale_out_cooldown: @service.cpu_tracking_scale_out_cooldown,
            target_value: @service.cpu_tracking_target_value,
          },
        })
      end

      def cpu_based_step_scaling_policy
        resp = Aws.app_autoscaling.put_scaling_policy({
          policy_name: "#{policy_prefix}-cpu-step-scaling-policy",
          service_namespace: "ecs",
          resource_id:,
          scalable_dimension: "ecs:service:DesiredCount",
          policy_type: "StepScaling",
          step_scaling_policy_configuration: {
            adjustment_type: "ChangeInCapacity",
            cooldown: @service.cpu_step_scaling_cooldown,
            step_adjustments: @service.cpu_step_scaling_steps,
            metric_aggregation_type: "Maximum",
          },
        })

        policy_arn = resp.policy_arn

        Aws.cloudwatch.put_metric_alarm({
          alarm_name: "#{policy_prefix}-cpu-alarm",
          alarm_actions: [policy_arn],
          comparison_operator: "GreaterThanOrEqualToThreshold",
          period: 60,
          evaluation_periods: 1,
          metric_name: "CPUUtilization",
          namespace: "AWS/ECS",
          statistic: "Average",
          threshold: @service.cpu_step_scaling_threshold,
          dimensions: [
            {
              name: "ClusterName",
              value: @service.cluster.name,
            },
            {
              name: "ServiceName",
              value: @service.name,
            },
          ],
        })
      end

      def resource_id
        "service/#{@service.cluster.name}/#{@service.name}"
      end

      def policy_prefix
        "#{@service.app.name}-#{@service.name}"
      end
    end
  end
end
