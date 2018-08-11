require 'thor'
require 'eucalypt/app'
require 'eucalypt/helpers/colorize'

module Eucalypt
  module List
    include Eucalypt::Helpers
    using Colorize

    INDENT = 2.freeze

    def help(shell, subcommand = false)
      list = printable_commands(true, subcommand)
      Thor::Util.thor_classes_in(self).each do |klass|
        list += klass.printable_commands(false)
      end

      list.reject! do |l|
        cmd = l.first
        cmd.include?('help') || cmd.include?('-H')
      end
      list.map {|l| l.last.sub!(?#, '·'.colorize(:pale_blue, :bold)+'›')}

      if defined?(@package_name) && @package_name
        shell.say "#{@package_name} commands:"
      else
        shell.say
        shell.say "#{"Commands".colorize(:bold)}:"
      end

      shell.print_table(list, indent: INDENT, truncate: false)
      shell.say
      class_options_help(shell)

      shell.say "For more information about a specific command, use #{"eucalypt -H".colorize(:pale_blue)}."
      shell.say "Example: eucalypt -H generate scaffold".colorize(:grey)
    end
  end
end