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

    def retrieve_env_vars
      EnvVar.retrieve(app.name, @in_app_name)
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

    def subnets
      @subnets ||= fetch_subnets(vpc_id)
    end

    def vpc_id
      @vpc_id ||= fetch_vpc_id
    end

    def fetch_vpc_id
      result = Aws.ec2.describe_vpcs({
                                       filters: [
                                         { name: "tag:Name", values: ["#{cluster_name}-vpc"] },
                                       ],
                                     })
      result.vpcs[0].vpc_id
    end

    def fetch_subnets(vpc_id)
      result = Aws.ec2.describe_subnets({
                                          filters: [
                                            { name: "vpc-id", values: [vpc_id] },
                                          ],
                                        })
      result.subnets
    end
  end
end
