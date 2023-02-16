module Rore
  class App
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def defaults
      @defaults ||= Defaults.new(self)
    end

    def vpc
      @vpc ||= Vpc.new(self)
    end

    def parameter_store
      @parameter_store ||= ParameterStore.new(self)
    end

    def roles
      @roles ||= Roles.new(self)
    end

    def task_definitions
      @task_definitions || TaskDefinitions.new(self)
    end

    def cluster
      @cluster ||= Cluster.new(self)
    end
  end
end
