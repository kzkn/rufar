module Rufar
  class Vpc
    Resource = Struct.new(:id)

    def initialize(app)
      @app = app
    end

    def subnets
      @subnets ||= fetch_subnets.map { Resource.new(_1.subnet_id) }
    end

    def security_groups
      @security_groups ||= fetch_security_groups.map { Resource.new(_1.group_id) }
    end

    private

    def vpc
      @vpc ||= fetch_vpc
    end

    def fetch_vpc
      result = Aws.ec2.describe_vpcs(vpc_filter)
      result.vpcs[0]
    end

    def vpc_filter
      if Rufar.config.vpc_id
        {
          vpc_ids: [Rufar.config.vpc_id],
        }
      else
        {
          filters: [
            { name: "tag:Name", values: [@app.defaults.vpc_name] },
          ],
        }
      end
    end

    def fetch_subnets
      result = Aws.ec2.describe_subnets(subnets_filter)
      result.subnets
    end

    def subnets_filter
      filters = [{ name: "vpc-id", values: [vpc.vpc_id] }]
      if Rufar.config.subnets
        { subnet_ids: Rufar.config.subnets, filter: }
      else
        {
          filters: [
            *filters,
            { name: "tag:Purpose", values: ["rufar"] },
          ],
        }
      end
    end

    def fetch_security_groups
      result = Aws.ec2.describe_security_groups(security_groups_filter)
      result.security_groups
    end

    def security_groups_filter
      filters = [{ name: "vpc-id", values: [vpc.vpc_id] }]
      if Rufar.config.security_groups
        { group_ids: Rufar.config.security_groups, filter: }
      else
        {
          filters: [
            *filters,
            { name: "tag:Purpose", values: ["rufar"] },
          ],
        }
      end
    end
  end
end
