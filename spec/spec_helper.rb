# frozen_string_literal: true

require "protoform"
require "debug"
require "phlex/testing/capybara"
# require "phlex-rails"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Phlex::Testing::Capybara::ViewHelper, type: :view
  # config.include Phlex::Testing::Rails::ViewHelper, type: :view
end
