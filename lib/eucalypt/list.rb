require 'thor'
require 'eucalypt/helpers/app'
require 'eucalypt/helpers/colorize'

module Eucalypt
  module List
    INDENT = 2.freeze

    def help(shell, subcommand = false)
      list = printable_commands(true, subcommand)
      Thor::Util.thor_classes_in(self).each do |klass|
        list += klass.printable_commands(false)
      end

      #list.reject! {|l| l[0].split[1] == 'help'}
      list.reject! {|l| l.first.include? 'help'}
      list.map {|l| l.last.sub!(?#, '·'.colorize(:pale_blue, :bold)+'›')}

      if defined?(@package_name) && @package_name
        shell.say "#{@package_name} commands:"
      else
        shell.say
        shell.say "#{"Commands".colorize(:bold)}:"
      end

      shell.print_table(list, indent: INDENT, :truncate => true)
      #shell.say
      class_options_help(shell)
    end
  end
end