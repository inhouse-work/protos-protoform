require "bundler"

class Protoform::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  APPLICATION_CONFIGURATION_PATH = Rails.root.join("config/application.rb")

  def install_phlex_rails
    return if gem_in_bundle? "phlex-rails"

    gem "phlex-rails"
    generate "phlex:install"
  end

  def autoload_components
    return unless APPLICATION_CONFIGURATION_PATH.exist?

    inject_into_class(
      APPLICATION_CONFIGURATION_PATH,
      "Application",
      %(    config.autoload_paths << "\#{root}/app/views/forms"\n)
    )
  end

  def create_application_form
    template "application_form.rb", Rails.root.join("app/views/forms/application_form.rb")
  end

  private
    def gem_in_bundle?(gem_name)
      Bundler.load.specs.any? { |spec| spec.name == gem_name }
    end
end
