require 'eucalypt/eucalypt-generate/namespaces/generate-controller/generators/controller'
require 'eucalypt/errors'

module Eucalypt
  class Generate < Thor
    option :spec, type: :boolean, default: true, desc: "Include a controller spec file"
    option :rest, aliases: '-r', type: :boolean, default: false,  desc: "Generate REST routes for the controller"
    desc "controller [NAME]", "Generates a controller"
    def controller(name)
      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        controller = Eucalypt::Generators::Controller.new
        controller.destination_root = directory
        controller.generate(
          name: name,
          spec: options[:spec],
          rest: options[:rest]
        )
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end