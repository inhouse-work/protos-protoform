# frozen_string_literal: true

require "zeitwerk"
require "protos"

module Protoform
  Loader = Zeitwerk::Loader.for_gem.tap do |loader|
    loader.ignore "#{__dir__}/generators"
    loader.inflector.inflect(
      "dom" => "DOM"
      # rubocop:enable Style/StringHashKeys
    )
    loader.setup
  end

  class Error < StandardError; end
end

def Protoform(...) # rubocop:disable Naming/MethodName, Style/TopLevelMethodDefinition
  Protoform::Namespace.root(...)
end
