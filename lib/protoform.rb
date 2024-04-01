require "zeitwerk"
require "protos"

module Protoform
  Loader = Zeitwerk::Loader.for_gem.tap do |loader|
    loader.ignore "#{__dir__}/generators"
    loader.inflector.inflect(
      dom: "DOM"
    )
    loader.setup
  end

  class Error < StandardError; end
end

def Protoform(...) # rubocop:disable Naming/MethodName, Style/TopLevelMethodDefinition
  Protoform::Namespace.root(...)
end
