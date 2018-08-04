require_relative 'destroy-controller'
require_relative 'destroy-helper'
require_relative 'destroy-model'

module Eucalypt
  class Destroy < Thor
    desc "scaffold [NAME]", "Destroys a scaffold"
    def scaffold(name = nil)
      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        scaffolds = Dir[File.join directory, 'app', '{controllers,models,helpers}', '*.rb'].map do |f|
          File.basename(f).split(?_).first.split(?.).first
        end

        scaffolds.reject!{|f|f == 'application'}
        scaffolds.uniq!

        if scaffolds.empty?
          Eucalypt::Error.no_scaffolds
          return
        end

        if name

          if scaffolds.include? name
            controller(name)
            helper(name)
            model(name)
          else
            Eucalypt::Error.no_scaffolds
          end

        else

          scaffolds_hash = {}
          scaffold_numbers = []

          scaffolds.each_with_index do |scaffold, i|
            scaffold_numbers << (i+1).to_s
            scaffolds_hash[(i+1).to_s.to_sym] = scaffold
            puts "\e[1m#{i+1}\e[0m: #{scaffold}"
          end

          scaffold_number = ask("\nEnter the number of the scaffold to delete:", limited_to: scaffold_numbers)
          scaffold_name = scaffolds_hash[scaffold_number.to_sym]

          controller(scaffold_name)
          helper(scaffold_name)
          model(scaffold_name)

        end

      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end