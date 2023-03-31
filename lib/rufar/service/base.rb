module Rufar
  module Service
    class Base
      attr_reader :arn

      def initialize(app, cluster)
        @app = app
        @cluster = cluster
      end

      def name
        raise NotImplementedError
      end

      def register_new_task_definition(image_uri)
        raise NotImplementedError
      end

      def deploy(task_definition)
        unless create_service(task_definition)
          update_service(task_definition)
        end
      end

      private

      def create_service(task_definition)
        return if exists?

        result = Aws.ecs.create_service(service_params(task_definition))
        @arn = result.service.service_arn
      end

      def service_params(task_definition)
        raise NotImplementedError
      end

      def task_definition_family
        "#{@cluster.name}_#{name}"
      end

      def subnets
        @app.vpc.subnets.map(&:id)
      end

      def security_groups
        @app.vpc.security_groups.map(&:id)
      end

      def update_service(task_definition)
        Aws.ecs.update_service({
          cluster: @cluster.name,
          service: @arn,
          task_definition: task_definition.arn,
        })
      end

      def exists?
        fetch
        !!@arn
      end

      def fetch
        result = Aws.ecs.describe_services({ cluster: @cluster.name, services: [name] })
        service = result.services.find { |s| s.service_name == name && s.status == "ACTIVE" }
        @arn = service&.service_arn
      end

      def choose_command(primary_command, default_command)
        if primary_command == :image_defined_command
          nil
        else
          primary_command || default_command
        end
      end
    end
  end
end
