module Rore
  class Cluster
    attr_reader :app, :arn

    def initialize(app, in_app_name)
      @app = app
      @in_app_name = in_app_name
      @arn = nil
    end

    def cluster_name
      "#{app.name}_#{@in_app_name}"
    end

    def create_cluster
      return if exists?

      result = Aws.ecs.create_cluster({ cluster_name: cluster_name })
      @arn = result.cluster.cluster_arn
    end

    def exists?
      fetch
      !!@arn
    end

    def fetch
      result = Aws.ecs.describe_clusters({ clusters: [cluster_name] })
      cluster = result.clusters.find { |c| c.cluster_name == cluster_name }
      @arn = cluster&.cluster_arn
    end
  end
end
