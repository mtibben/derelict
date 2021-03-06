module Derelict
  # Base class for parsers, which extract data from command output
  class Parser
    autoload :BoxList,    "derelict/parser/box_list"
    autoload :PluginList, "derelict/parser/plugin_list"
    autoload :Status,     "derelict/parser/status"
    autoload :Version,    "derelict/parser/version"

    # Include "logger" method to get a logger for this class
    include Utils::Logger

    attr_reader :output

    # Initializes the parser with the output it will be parsing
    def initialize(output)
      @output = output
      logger.debug "Successfully initialized #{description}"
    end

    # Provides a description of this Parser
    #
    # Mainly used for log messages.
    def description
      "Derelict::Parser (unknown type)"
    end
  end
end
