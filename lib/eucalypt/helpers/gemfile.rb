require 'thor'
module Eucalypt
  module Helpers
    def add_to_gemfile(description, gems, directory)
      gemfile = File.join directory, 'Gemfile'

      File.open(gemfile) do |f|
        includes_gems = []
        contents = f.read
        gems.each do |gem, version|
          if contents.include? "gem '#{gem}'"
            includes_gems << true
          end
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

    def gemfile_include?(gems, directory)
      gemfile = File.join directory, 'Gemfile'
      includes_gems = []
      File.open(gemfile) do |f|
        contents = f.read
        gems.each do |gem|
          if contents.include? "gem '#{gem}'"
            includes_gems << true
          else
            includes_gems << false
          end
        end
      end
      includes_gems.all? {|present| present == true}
    end

    def gem_check(gems, command, directory)
      if gemfile_include? gems, directory
        true
      else
        Eucalypt::Error.no_gems(gems, command)
        false
      end
    end
  end
end