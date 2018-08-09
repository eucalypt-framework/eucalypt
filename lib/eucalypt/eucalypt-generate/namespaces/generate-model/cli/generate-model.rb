require 'eucalypt/eucalypt-generate/namespaces/generate-model/generators/model'
require 'eucalypt/helpers/app'
require 'eucalypt/errors'

module Eucalypt
  class Generate < Thor
    option :table, type: :boolean, default: true, desc: "Generate table migration"
    option :spec, type: :boolean, default: true, desc: "Include a model spec file"
    desc "model [NAME] *[COLUMN∶TYPE]", "Generates a model".colorize(:grey)
    def model(name, *columns)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        validation = Eucalypt::Helpers::Migration::Validation.new columns
        return if validation.any_invalid?
        model = Eucalypt::Generators::Model.new
        model.destination_root = directory
        model.generate(name: name, spec: options[:spec], table: options[:table], columns: columns)
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end