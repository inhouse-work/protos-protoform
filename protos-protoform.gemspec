# frozen_string_literal: true

require_relative "lib/protoform/version"

Gem::Specification.new do |spec|
  spec.name = "protos-protoform"
  spec.version = Protoform::VERSION
  spec.authors = ["Nolan Tait"]
  spec.email = ["nolanjtait@gmail.com"]

  spec.summary = "Phlex based form builder for Rails"
  spec.description = "Build phlex based forms using Rails conventions"
  spec.homepage = "https://github.com/inhouse-work/protos-protoform"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released. The
  # `git ls-files -z` loads the files in the RubyGem that have been added into
  # git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(
        *%w[
          bin/
          test/
          spec/
          features/
          .git
          .circleci
          appveyor
        ]
      )
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "phlex-rails", "~> 1.0"
  spec.add_dependency "protos", "~> 0.4"
  spec.add_dependency "zeitwerk", "~> 2.6"
  spec.metadata["rubygems_mfa_required"] = "true"
end
