module Rufar
  class Deploy
    def initialize(app)
      @app = app
    end

    def run(image_uri)
      Rufar.logger.info "Creating cluster"
      create_cluster

      Rufar.logger.info "Register task definition; image_uri=#{image_uri}"
      task_defs = register_task_definitions(image_uri)

      task_def = choose_task_definition(task_defs, release_task_definition)
      Rufar.logger.info "Run app release task; task_def=#{task_def.arn}"

      exit_code = run_release_task(task_def)
      if exit_code != 0
        Rufar.logger.error "Failed to run app release task; exit_code=#{exit_code}"
        raise "Failed to run app release task"
      end

      Rufar.logger.info "Deploy schedules"
      task_def = choose_task_definition(task_defs, @app.scheduler.scheduler_task_definition)
      @app.scheduler.deploy(task_def)

      Rufar.logger.info "Deploy services"
      deploy_service(task_defs)

      Rufar.logger.info "Wait services stable"
      @app.cluster.wait_services_stable
    end

    private

    def create_cluster
      @app.cluster.create
    end

    def register_task_definitions(image_uri)
      @app.cluster.register_task_definitions(image_uri)
    end

    def run_release_task(task_definition)
      @app.cluster.run_task(task_definition, release_command)
    end

    def choose_task_definition(task_definitions, name)
      task_definitions.transform_keys(&:name)[name.to_s]
    end

    def deploy_service(task_definitions)
      task_definitions.each do |service, task_definition|
        service.deploy(task_definition)
      end
    end

    def release_task_definition
      Rufar.config.oneoff_task_definition_service_name || "worker"
    end

    def release_command
      Rufar.config.release_command || %w[bin/rake app:release]
    end
  end
end
