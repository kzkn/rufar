# frozen_string_literal: true

require_relative "lib/rufar/version"

Gem::Specification.new do |spec|
  spec.name = "rufar"
  spec.version = Rufar::VERSION
  spec.authors = ["Kazuki Nishikawa"]
  spec.email = ["kzkn@users.noreply.github.com"]

  spec.summary = "Ruby On Rails on ECS"
  spec.description = "Ruby On Rails on ECS"
  spec.homepage = "https://github.com/kzkn/rufar"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/kzkn/rufar/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-ssm", "~> 1.148"
  spec.add_dependency "aws-sdk-ecs", "~> 1.110"
  spec.add_dependency "aws-sdk-ec2", "~> 1.365"
  spec.add_dependency "aws-sdk-iam", "~> 1.75"
  spec.add_dependency "aws-sdk-elasticloadbalancingv2", "~> 1.84"
  spec.add_dependency "aws-sdk-applicationautoscaling", "~> 1.68"
  spec.add_dependency "aws-sdk-cloudwatch", "~> 1.72"
  spec.add_dependency "aws-sdk-scheduler", "~> 1.2"
end
