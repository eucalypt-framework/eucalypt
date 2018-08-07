require 'thor'
require 'eucalypt/helpers/colorize'

module Eucalypt
  module List
    def help(shell, subcommand = false)
      list = printable_commands(true, subcommand)
      Thor::Util.thor_classes_in(self).each do |klass|
        list += klass.printable_commands(false)
      end

      #list.reject! {|l| l[0].split[1] == 'help'}
      list.reject! {|l| l.first.include? 'help'}

      if defined?(@package_name) && @package_name
        shell.say "#{@package_name} commands:"
      else
        shell.say
        shell.say "#{"Commands".colorize(:bold)}:"
      end

      shell.print_table(list, :indent => 2, :truncate => true)
      shell.say
      class_options_help(shell)

      shell.say "All commands can be run with #{'-h'.colorize(:pale_blue)} (or #{'--help'.colorize(:pale_blue)}) for more information."
    end
  end
end