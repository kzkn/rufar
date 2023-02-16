module Rore
  class Task
    def initialize(app, cluster)
      @app = app
      @cluster = cluster
    end

    def run(task_definition, command)
      result = Aws.ecs.run_task(task_params(task_definition, command))
      @arn = result.tasks[0].task_arn
    end

    def wait
      Aws.ecs.wait_until(:tasks_stopped, { cluster: @cluster.name, tasks: [@arn] })
    end

    def task_params(task_definition, command)
      {
        cluster: @cluster.name,
        launch_type: "FARGATE",
        task_definition: task_definition.arn,
        overrides: {
          container_overrides: [
            {
              name: container_name,
              command: command,
            },
          ],
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

    def container_name
      Rore.config.container_name || @app.defaults.container_name
    end

    def subnets
      @app.vpc.subnets.map(&:id)
    end

    def security_groups
      @app.vpc.security_groups.map(&:id)
    end
  end
end
