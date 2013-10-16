require "derelict/version"
require "log4r"
require "shell/executer"

module Derelict
  autoload :Connection,     "derelict/connection"
  autoload :Exception,      "derelict/exception"
  autoload :Instance,       "derelict/instance"
  autoload :Log4r,          "derelict/log4r"
  autoload :Parser,         "derelict/parser"
  autoload :VirtualMachine, "derelict/virtual_machine"

  # Make functions accessible by Derelict.foo and private when included
  module_function

  # Retrieves the base Log4r::Logger used by Derelict
  def logger
    ::Log4r::Logger["derelict"] || ::Log4r::Logger.new("derelict")
  end

  # Creates a new Derelict instance for a Vagrant installation
  #
  #   * path: The path to the Vagrant installation (optional, defaults
  #           to Instance::DEFAULT_PATH)
  def instance(path = Instance::DEFAULT_PATH)
    Instance.new(path).validate!
  end
end
