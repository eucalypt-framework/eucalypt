require 'thor'
require 'eucalypt/helpers'
require 'eucalypt/errors'

module Eucalypt
  class Destroy < Thor
    module Helpers
      include Eucalypt::Helpers

      def delete_mvc(mvc_file, name)
        directory = File.expand_path('.')
        if Eucalypt.app? directory
          files = Dir[File.join directory, 'app', "#{mvc_file}s", '*.rb']
          file_names = files.map{|c| File.basename(c).split(?_).first}.reject{|n| n=='application'}

          if files.empty?
            Eucalypt::Error.no_mvc(mvc_file)
            return
          end

          file_name = String.new
          spec_file_name = String.new

          if name
            # If name given
            file_name = mvc_file == :model ? "#{name}.rb" : "#{name}_#{mvc_file}.rb"
            spec_file_name = mvc_file == :model ? "#{name}_spec.rb" : "#{name}_#{mvc_file}_spec.rb"

            unless file_names.include? file_name
              Eucalypt::Error.no_mvc(mvc_file)
              return
            end
          else
            # If name not given
            files = Dir[File.join directory, 'app', "#{mvc_file}s", "*.rb"].reject{|f| File.basename(f).include? 'application'}
            if files.empty?
              Eucalypt::Error.no_mvc(mvc_file)
              return
            end

            puts

            files_hash = {}
            file_numbers = []
            files.each_with_index do |file, i|
              number = (i+1).to_s
              file_numbers << number
              files_hash[number.to_sym] = File.basename file
              puts "#{number.colorize(:bold)}: #{File.basename file}"
            end
            file_number = ask "\nEnter the number of the #{mvc_file} to delete:", limited_to: file_numbers

            file_name = files_hash[file_number.to_sym]
            spec_file_name = file_name.gsub('.rb','_spec.rb')
          end

          Out.info "This command #{"will not".colorize(:bold)} delete any associated table." if mvc_file == :model

          # Deleting MVC file
          file_path = File.join directory, "app", "#{mvc_file}s", file_name
          delete_file = ask Out.warning_message("Delete #{mvc_file} file #{file_name.colorize(:bold)}?"), limited_to: %w[y Y Yes YES n N No NO]
          remove_file(file_path) if %w[y Y Yes YES].include? delete_file

          # Deleting MVC file spec
          spec_file_path = File.join(directory, "spec", "#{mvc_file}s", spec_file_name)
          return unless File.exist? spec_file_path
          delete_file_spec = ask Out.warning_message("Delete #{mvc_file} spec file #{spec_file_name.colorize(:bold)}?"), limited_to: %w[y Y Yes YES n N No NO]
          remove_file(spec_file_path) if %w[y Y Yes YES].include? delete_file_spec
        else
          Eucalypt::Error.wrong_directory
        end
      end
    end
  end
end