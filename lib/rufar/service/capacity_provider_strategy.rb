module Rufar
  module Service
    class CapacityProvierStrategy
      def initialize(service)
        @service = service
      end

      def strategies
        case @service.capacity_provider_strategy_mode
        when :all_spot
          spot_only_strategies
        when :no_spot
          fargate_only_strategies
        when :hybrid
          hybrid_strategies
        when :custom
          @service.custom_capacity_provider_strategies
        end
      end

      private

      def desired_count
        @service.desired_count
      end

      def spot_only_strategies
        [
          {
            capacity_provider: "FARGATE",
            base: 0,
            weight: 0,
          },
          {
            capacity_provider: "FARGATE_SPOT",
            base: desired_count,
            weight: 1,
          },
        ]
      end

      def fargate_only_strategies
        [
          {
            capacity_provider: "FARGATE",
            base: desired_count,
            weight: 1,
          },
          {
            capacity_provider: "FARGATE_SPOT",
            base: 0,
            weight: 0,
          },
        ]
      end

      def hybrid_strategies
        [
          {
            capacity_provider: "FARGATE",
            base: 0,
            weight: 1,
          },
          {
            capacity_provider: "FARGATE_SPOT",
            base: 0,
            weight: desired_count - 1,
          },
        ]
      end
    end
  end
end
