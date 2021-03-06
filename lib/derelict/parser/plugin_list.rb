module Derelict
  # Parses the output of "vagrant plugin list"
  class Parser::PluginList < Parser
    autoload :InvalidFormat, "derelict/parser/plugin_list/invalid_format"
    autoload :NeedsReinstall, "derelict/parser/plugin_list/needs_reinstall"

    # Include "memoize" class method to memoize methods
    extend Memoist

    # Regexp to parse a plugin line into a plugin name and version
    #
    # Capture groups:
    #
    #   1. Plugin name, as listed in the output
    #   2. Currently installed version (without surrounding brackets)
    PARSE_PLUGIN = %r[
      ^(.*)                  # Plugin name starts at the start of the line.
      \                      # Version is separated by a space character,
      \(([0-9\-_.]+)(, .*)?\) # contains version string surrounded by brackets
      $                      # at the end of the line.
    ]x                       # Ignore whitespace to allow these comments.

    # Regexp to determine whether plugins need to be reinstalled
    NEEDS_REINSTALL = %r[
      ^The\splugins\sbelow\swill\snot\sbe\sloaded\suntil\sthey're\s
      uninstalled\sand\sreinstalled:$
    ]x

    # Retrieves a Set containing all the plugins from the output
    def plugins
      raise NeedsReinstall, output if needs_reinstall?
      plugin_lines.map {|l| parse_line l.match(PARSE_PLUGIN) }.to_set
    end

    # Determines if old plugins need to be reinstalled
    def needs_reinstall?
      output =~ NEEDS_REINSTALL
    end

    # Provides a description of this Parser
    #
    # Mainly used for log messages.
    def description
      "Derelict::Parser::PluginList instance"
    end

    private
      # Retrieves an array of the plugin lines in the output
      def plugin_lines
        return [] if output.match /no plugins installed/i
        output.lines
      end

      # Parses a single line of the output into a Plugin object
      def parse_line(match)
        raise InvalidFormat.new "Couldn't parse plugin" if match.nil?
        Derelict::Plugin.new *match.captures[0..1]
      end
  end
end
