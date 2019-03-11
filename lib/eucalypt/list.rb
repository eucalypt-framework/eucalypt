require 'thor'
require 'eucalypt/app'
require 'eucalypt/helpers/colorize'

module Eucalypt
  module List
    include Eucalypt::Helpers
    using Colorize

    def help(shell, subcommand = false)
      list = printable_commands(true, subcommand)
      Thor::Util.thor_classes_in(self).each do |klass|
        list += klass.printable_commands(false)
      end

      indent = 2.freeze

      list.reject! do |l|
        cmd = l.first
        (/.*help.*/.match?(cmd) && /^(?!.*(helper))/.match?(cmd)) || cmd.include?('-H')
      end
      list.reject! {|l| /^(?!.*(init))/.match? l.first} if !Eucalypt.app? Dir.pwd

      list.map {|l| l.last.sub!(?#, '·'.colorize(:pale_blue, :bold)+'›')}

      if defined?(@package_name) && @package_name
        shell.say "#{@package_name} commands:"
      else
        shell.say
        shell.say "#{"Commands".colorize(:bold)}:"
      end

      shell.print_table(list, indent: indent, truncate: false)
      shell.say
      class_options_help(shell)

      if !Eucalypt.app? Dir.pwd
        shell.say "For more information about creating an application, use #{"eucalypt -H init".colorize(:pale_blue)}."
      else
        shell.say "For more information about a specific command, use #{"eucalypt -H".colorize(:pale_blue)}."
        shell.say "Example: eucalypt -H generate scaffold".colorize(:grey)
      end
    end
  end
end