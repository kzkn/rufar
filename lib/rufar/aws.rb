require "aws-sdk-ssm"
require "aws-sdk-ecs"
require "aws-sdk-ec2"
require "aws-sdk-iam"
require "aws-sdk-elasticloadbalancingv2"

module Rufar
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
        Rufar.config.aws_credentials || ::Aws::ECSCredentials.new
      end

      def region
        Rufar.config.aws_region || ENV["AWS_REGION"]
      end
    end
  end
end
