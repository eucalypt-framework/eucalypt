require 'thor'
require 'eucalypt/errors'

module Eucalypt
  module Helpers
    module Gemfile
      def gemfile_add(description, gems, directory)
        gemfile = File.join(directory, 'Gemfile')
        File.open gemfile do |f|
          includes_gems = []
          contents = f.read
          gems.each do |gem, _|
            includes_gems << true if contents.include? "gem '#{gem}'"
          end
          return unless includes_gems.empty?
        end

        append_to_file gemfile, "\n# #{description}\n"
        gems.each_with_index do |gemdata, i|
          gem, version = gemdata
          gem_string = "gem '#{gem}', '#{version}'" << (i==gems.size-1 ? '' : "\n")
          append_to_file gemfile, gem_string
        end
      end

      class << self
        def include?(gems, directory)
          includes_gems = []
          gemfile = File.join(directory, 'Gemfile')
          File.open gemfile do |f|
            contents = f.read
            gems.each {|gem| includes_gems << contents.include?("gem '#{gem}'") }
          end
          includes_gems.all? {|present| present == true}
        end

        def check(gems, command, directory)
          if include?(gems, directory)
            true
          else
            Eucalypt::Error.no_gems(gems, command)
            false
          end
        end
      end
    end
  end
end