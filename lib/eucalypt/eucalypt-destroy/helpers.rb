require 'thor'
require 'eucalypt/errors'

module Eucalypt
  class Destroy < Thor
    module Helpers
      def delete_mvc(mvc_file, name)
        directory = File.expand_path ?.
        if File.exist? File.join(directory, '.eucalypt')
          files = Dir[File.join directory, "app/#{mvc_file}s/*.rb"]
          file_names = if mvc_file == :model
            files.map{|c| File.basename(c).split(?.).first}
          else
            files.map{|c| File.basename(c).split(?_).first}.reject{|n| n=='application'}
          end

          if files.empty?
            Eucalypt::Error.no_mvc(mvc_file)
            return
          end

          if name

            name = name.downcase
            if file_names.include? name
              file_name = mvc_file == :model ? "#{name}.rb" : "#{name}_#{mvc_file}.rb"
              # Deleting MVC file
              delete_file = ask("\e[1;93mWARNING\e[0m: Delete #{mvc_file} \e[1m#{file_name}\e[0m?", limited_to: %w[y Y Yes YES n N No NO])
              return unless %w[y Y Yes YES].include? delete_file
              remove_file(File.join directory, "app/#{mvc_file}s", file_name)

              # Deleting MVC file spec
              spec_file_name = mvc_file == :model ? "#{name}_spec.rb" : "#{name}_#{mvc_file}_spec.rb"
              spec_file_path = File.join(directory, "spec/#{mvc_file}s", spec_file_name)
              return unless File.exist? spec_file_path
              delete_file_spec = ask("\e[1;93mWARNING\e[0m: Delete #{mvc_file} spec \e[1m#{spec_file_name}\e[0m?", limited_to: %w[y Y Yes YES n N No NO])
              return unless %w[y Y Yes YES].include? delete_file_spec
              remove_file(spec_file_path)
            else
              Eucalypt::Error.no_mvc(mvc_file)
              return
            end

          else

            files = Dir[File.join directory, 'app', "#{mvc_file}s", "*.rb"].reject{|f| File.basename(f).include? 'application'}
            if files.empty?
              Eucalypt::Error.no_mvc(mvc_file)
              return
            end

            puts

            files_hash = {}
            file_numbers = []

            files.each_with_index do |file, i|
              file_numbers << (i+1).to_s
              files_hash[(i+1).to_s.to_sym] = File.basename file
              puts "\e[1m#{i+1}\e[0m: #{File.basename file}"
            end

            file_number = ask("\nEnter the number of the #{mvc_file} to delete:", limited_to: file_numbers)
            file = files_hash[file_number.to_sym]
            delete_file = ask("\e[1;93mWARNING\e[0m: Delete #{mvc_file} file \e[1m#{file}\e[0m?", limited_to: %w[y Y Yes YES n N No NO])
            return unless %w[y Y Yes YES].include? delete_file
            remove_file(File.join directory, 'app', "#{mvc_file}s", file)

            spec_file = file.gsub('.rb','_spec.rb')
            delete_spec_file = ask("\e[1;93mWARNING\e[0m: Delete #{mvc_file} spec file \e[1m#{spec_file}\e[0m?", limited_to: %w[y Y Yes YES n N No NO])
            return unless %w[y Y Yes YES].include? delete_file
            remove_file(File.join directory, 'spec', "#{mvc_file}s", spec_file)
          end
        else
          Eucalypt::Error.wrong_directory
        end
      end
    end
  end
end