module Rore
  class Cluster
    def initialize(app)
      @app = app
    end

    def name
      Rore.config.cluster_name || @app.defaults.cluster_name
    end

    def create
      return if exists?

      result = Aws.ecs.create_cluster({ cluster_name: name })
      @arn = result.cluster.cluster_arn
    end

    def services
      @services ||= [
        Service::Web.new(@app, self),
        Service::Worker.new(@app, self),
      ]
    end

    def register_task_definitions(image_uri)
      task_definitions = services.map { _1.register_new_task_definition(image_uri) }
      services.zip(task_definitions).to_h
    end

    def deploy_services(task_definition)
      services.map { _1.deploy(image_uri) }
    end

    def run_task(task_definition, command)
      task = Task.new(@app, self)
      task.run(task_definition, command)
      task.wait
    end

    private

    def exists?
      fetch unless @arn
      !!@arn
    end

    def fetch
      result = Aws.ecs.describe_clusters({ clusters: [name] })
      cluster = result.clusters.find { |c| c.cluster_name == name }
      @arn = cluster&.cluster_arn
    end
  end
end
