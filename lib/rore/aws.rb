require "aws-sdk-ssm"
require "aws-sdk-ecs"
require "aws-sdk-ec2"
require "aws-sdk-iam"
require "aws-sdk-elasticloadbalancingv2"

module Rore
  class Aws
    class << self
      def ssm
        ::Aws::SSM::Client.new(region: region, credentials: credentials)
      end

      def ecs
        ::Aws::ECS::Client.new(region: region, credentials: credentials)
      end

      def ec2
        ::Aws::EC2::Client.new(region: region, credentials: credentials)
      end

      def iam
        ::Aws::IAM::Client.new(region: region, credentials: credentials)
      end

      def elb
        ::Aws::ElasticLoadBalancingV2::Client.new(region: region, credentials: credentials)
      end

      def credentials
        ::Aws::Credentials.new(
          Rore.config.aws_access_key_id,
          Rore.config.aws_secret_access_key
        )
      end

      def region
        Rore.config.aws_region
      end
    end
  end
end
