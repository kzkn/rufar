module Rore
  class Deploy
    def initialize(app)
      @app = app
    end

    def run(image_uri)
      Rore.logger.info "Creating cluster"
      create_cluster

      Rore.logger.info "Register task definition; image_uri=#{image_uri}"
      task_defs = register_task_definitions(image_uri)

      task_def = choose_app_release_task_definition(task_defs)
      Rore.logger.info "Run app release task; task_def=#{task_def.arn}"
      run_app_release(task_def)

      Rore.logger.info "Deploy services"
      deploy_service(task_defs)
    end

    private

    def create_cluster
      @app.cluster.create
    end

    def register_task_definitions(image_uri)
      @app.cluster.register_task_definitions(image_uri)
    end

    def run_app_release(task_definition)
      @app.cluster.run_task(task_definition, app_release_command)
    end

    def choose_app_release_task_definition(task_definitions)
      task_definitions.transform_keys(&:name)[app_release_task_definition]
    end

    def deploy_service(task_definitions)
      task_definitions.each do |service, task_definition|
        service.deploy(task_definition)
      end
    end

    def app_release_task_definition
      Rore.config.app_release_task_definition_service_name || "web"
    end

    def app_release_command
      Rore.config.app_release_command || %w[bin/rake app:release]
    end
  end
end
