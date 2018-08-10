require 'eucalypt/helpers/inflect'
require 'json'
require 'yaml'

module Eucalypt
  class Static
    include Eucalypt::Helpers

    FILE_TYPES = {yaml: %w[yml yaml], json: %w[json geojson]}

    def initialize(directory, symbolize: false)
      contents = Dir[File.join directory, '*']
      files = contents.select {|f| File.file? f}
      subdirectories = contents.select {|f| File.directory? f}
      files.each {|f| define_file_accessor f, symbolize}
      subdirectories.each {|s| define_subdirectory_accessor s, symbolize}
    end

    private

    def define_file_accessor(file, symbolize)
      file_name = File.basename file, '.*'
      extension = File.extname(file).sub /\A./, ''
      file_type = nil
      FILE_TYPES.each {|t, e| file_type = t if e.include? extension}
      raise TypeError.new("Unsupported extension: .#{extension}") if file_type.nil?
      define_singleton_method Inflect.resource_keep_inflection(file_name) do
        hash = parse(file_type, file)
        hash = hash ? hash : {}
        symbolize ? hash.deep_symbolize_keys : hash
      end
    end

    def define_subdirectory_accessor(subdirectory, symbolize)
      subdirectory_name = subdirectory.split(File::SEPARATOR).last
      define_singleton_method Inflect.resource_keep_inflection(subdirectory_name) do
        Static.new subdirectory, symbolize: symbolize
      end
    end

    def parse(file_type, file)
      case file_type
      when :yaml then YAML.load_file(file)
      when :json then JSON.parse(File.read file)
      end
    end
  end
end