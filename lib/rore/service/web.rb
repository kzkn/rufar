module Rore
  module Service
    class Web < Base
      def task_definition_params(image_uri)
        {
          cpu:,
          memory:,
          family: task_definition_name,
          execution_role_arn:,
          container_definitions: [{
            name: task_definition_name,
            command: %w[bin/rails server],
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
    end
  end
end
