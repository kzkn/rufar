module Rore
  class TaskDefinitions
    def initialize(app)
      @app = app
    end

    def register(family, image_uri, command, port_mappings: nil)
      task_def = TaskDefinition.new(@app, family)
      task_def.register(image_uri, command, port_mappings:)
      task_def
    end

    class TaskDefinition
      attr_reader :arn

      def initialize(app, family)
        @app = app
        @family = family
      end

      def register(image_uri, command, port_mappings:)
        params = task_definition_params(image_uri, command, port_mappings:)
        result = Aws.ecs.register_task_definition(params)
        @arn = result.task_definition.task_definition_arn
      end

      def container_name
        Rore.config.container_name || @app.defaults.container_name
      end

      private

      def task_definition_params(image_uri, command, port_mappings:)
        {
          cpu:,
          memory:,
          family: @family,
          execution_role_arn:,
          task_role_arn:,
          requires_compatibilities: ["FARGATE"],
          network_mode: "awsvpc",
          container_definitions: [{
                                    name: container_name,
                                    image: image_uri,
                                    command:,
                                    secrets:,
                                    port_mappings:,
                                    log_configuration:,
                                  }],
        }
      end

      def cpu
        Rore.config.cpu || @app.defaults.cpu
      end

      def memory
        Rore.config.memory || @app.defaults.memory
      end

      def execution_role_arn
        @app.roles.execution_role.arn
      end

      def task_role_arn
        @app.roles.task_role.arn
      end

      def secrets
        @app.parameter_store.parameters.map { { name: _1.name, value_from: _1.arn } }
      end

      def awslogs_group
        Rore.config.awslogs_group || @app.defaults.awslogs_group
      end

      def awslogs_region
        Rore.config.awslogs_region || @app.defaults.awslogs_region
      end

      def log_configuration
        {
          log_driver: "awslogs",
          options: {
            "awslogs-group" => awslogs_group,
            "awslogs-region" => awslogs_region,
            "awslogs-create-group" => "true",
            "awslogs-stream-prefix" => @family,
          },
        }
      end
    end
  end
end
