require 'eucalypt/eucalypt-generate/namespaces/generate-model/generators/model'
require 'eucalypt/errors'

module Eucalypt
  class Generate < Thor
    option :spec, type: :boolean, default: true, desc: "Include a model spec file"
    desc "model [NAME]", "Generates a model"
    def model(name)
      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        model = Eucalypt::Generators::Model.new
        model.destination_root = directory
        model.generate(name: name, spec: options[:spec])
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end