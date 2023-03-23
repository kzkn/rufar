module Rufar
  class DSL
    def apply_to(config)
      Config::CONFIGURATIONS.each do |key|
        value = instance_variable_get("@#{key}")
        config.public_send("#{key}=", value)
      end
    end

    def aws(region: nil, credentials: nil)
      @aws_region = region
      @aws_credentials = credentials
    end

    def vpc(vpc_id: nil, subnets: nil, security_groups: nil)
      @vpc_id = vpc_id
      @subnets = subnets
      @security_groups = security_groups
    end

    def iam(task_role_name: nil, execution_role_name: nil)
      @task_role_name = task_role_name
      @execution_role_name = execution_role_name
    end

    def parameter_store(prefix: nil)
      @parameters_prefix = prefix
    end

    def task_definition(container_name: nil, cpu: nil, memory: nil, awslogs_group: nil, awslogs_region: nil)
      @container_name = container_name
      @cpu = cpu
      @memory = memory
      @awslogs_group = awslogs_group
      @awslogs_region = awslogs_region
    end

    def cluster(name: nil)
      @cluster_name = name
    end

    def web_service(name: nil, desired_count: nil, command: nil, deploy_maximum_percent: nil, deploy_minimum_healthy_percent: nil, cpu: nil, memory: nil)
      @web_service_name = name
      @web_desired_count = desired_count
      @web_command = command
      @web_deploy_maximum_percent = deploy_maximum_percent
      @web_deploy_minimum_healthy_percent = deploy_minimum_healthy_percent
      @web_cpu = cpu
      @web_memory = memory
    end

    def worker_service(name: nil, desired_count: nil, command: nil, deploy_maximum_percent: nil, deploy_minimum_healthy_percent: nil, cpu: nil, memory: nil)
      @worker_service_name = name
      @worker_desired_count = desired_count
      @worker_command = command
      @worker_deploy_maximum_percent = deploy_maximum_percent
      @worker_deploy_minimum_healthy_percent = deploy_minimum_healthy_percent
      @worker_cpu = cpu
      @worker_memory = memory
    end

    def release(task_definition_service_name: nil, command: nil)
      @app_release_task_definition_service_name = task_definition_service_name
      @app_release_command = command
    end
  end
end
