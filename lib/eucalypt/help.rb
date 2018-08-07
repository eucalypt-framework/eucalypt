require 'thor'
module Eucalypt
  module Help
    if Thor::HELP_MAPPINGS.any? { |cmd| ARGV.include? cmd }
      Thor::HELP_MAPPINGS.each do |cmd|
        if match = ARGV.delete(cmd)
          ARGV.unshift match
        end
      end
    end
  end
end