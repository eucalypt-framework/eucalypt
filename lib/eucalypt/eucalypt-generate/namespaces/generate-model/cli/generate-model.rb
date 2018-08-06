require 'eucalypt/eucalypt-generate/namespaces/generate-model/generators/model'
require 'eucalypt/helpers/app'
require 'eucalypt/errors'

module Eucalypt
  class Generate < Thor
    option :spec, type: :boolean, default: true, desc: "Include a model spec file"
    desc "model [NAME]", "Generates a model".colorize(:grey)
    def model(name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        model = Eucalypt::Generators::Model.new
        model.destination_root = directory
        model.generate(name: name, spec: options[:spec])
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end