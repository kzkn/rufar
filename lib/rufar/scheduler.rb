require "forwardable"

module Rufar
  class Scheduler
    def initialize(app)
      @app = app
    end

    def scheduler_task_definition
      Rufar.config.oneoff_task_definition_service_name || "worker"
    end

    def deploy(task_definition)
      @revision = task_definition.revision
      older_schedule_groups.each do |sg|
        delete_schedule_group(sg)
      end

      group_name = create_schedule_group
      schedules.each do |schedule|
        schedule.create(group_name, task_definition)
      end
    end

    def older_schedule_groups
      groups = []
      name_prefix = "#{@app.name}_"
      resp = Aws::scheduler.list_schedule_groups({ name_prefix: })
      loop do
        groups.concat(resp.schedule_groups.select { old?(_1) })
        break unless resp.next_token

        resp = Aws::scheduler.list_schedule_groups({ name_prefix:, next_token: resp.next_token })
      end

      groups
    end

    def old?(schedule_group)
      revision = schedule_group.name.gsub(/^#{schedule_group_name_prefix}/, "").to_i
      revision < @revision
    end

    def delete_schedule_group(schedule_group)
      Aws.scheduler.delete_schedule_group({ name: schedule_group.name })
    end

    def create_schedule_group
      name = "#{schedule_group_name_prefix}#{@revision}"
      Aws::scheduler.create_schedule_group({ name: })
      name
    end

    def schedule_group_name_prefix
      "#{@app.name}_schedules_"
    end

    def schedules
      Rufar.config.schedules.map { Schedule.new(@app, _1) }
    end

    class Schedule
      extend Forwardable

      def initialize(app, config)
        @app = app
        @config = config
      end

      def_delegators :@config, :expression, :name, :command, :cpu, :memory

      def create(group_name, task_definition)
        Aws.scheduler.create_schedule({
          group_name:,
          name: "#{@app.name}_#{name}",
          schedule_expression: expression,
          schedule_expression_timezone: timezone,
          flexible_time_window: {
            mode: "OFF",
          },
          state: "ENABLED",
          target: {
            arn: @app.cluster.arn,
            ecs_parameters: {
              launch_type: "FARGATE",
              network_configuration: {
                awsvpc_configuration: {
                  assign_public_ip: "ENABLED",
                  security_groups: security_groups,
                  subnets: subnets,
                },
              },
              task_count: 1,
              task_definition_arn: task_definition.arn,
            },
            input: as_input(task_definition).to_json,
            role_arn:,
          },
        })
      end

      def subnets
        @app.vpc.subnets.map(&:id)
      end

      def security_groups
        @app.vpc.security_groups.map(&:id)
      end

      def timezone
        Rufar.config.scheduler_timezone || @app.defaults.scheduler_timezone
      end

      def as_input(task_definition)
        cpu = self.cpu || Rufar.config.scheduler_default_cpu
        memory = self.memory || Rufar.config.scheduler_default_memory
        {
          cpu: cpu&.to_s,
          memory: memory&.to_s,
          containerOverrides: [
            {
              name: task_definition.container_name,
              command:,
            },
          ],
        }.compact
      end

      def role_arn
        @app.roles.scheduler_role.arn
      end
    end
  end
end
