module Rufar
  class Defaults
    def initialize(app)
      @app = app
    end

    def name
      @app.name
    end

    def hyphenized_name
      name.tr("_", "-")
    end

    def vpc_name
      "#{name}_vpc"
    end

    def parameters_prefix
      "/#{name}"
    end

    def task_role_name
      "#{name}_task_role"
    end

    def execution_role_name
      "#{name}_execution_role"
    end

    def scheduler_role_name
      "#{name}_scheduler_role"
    end

    def container_name
      "app"
    end

    def cpu
      256
    end

    def memory
      512
    end

    def awslogs_group
      name
    end

    def awslogs_region
      Aws.region
    end

    def cluster_name
      name
    end

    def web_service_name
      "web"
    end

    def worker_service_name
      "worker"
    end

    def target_group_name
      "#{hyphenized_name}-target-group"
    end

    def scheduler_timezone
      "Asia/Tokyo"
    end
  end
end
