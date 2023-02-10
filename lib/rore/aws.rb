require "aws-sdk-ssm"

module Rore
  class Aws
    class << self
      def ssm
        ::Aws::SSM::Client.new(region: region, credentials: credentials)
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
