require 'thor'
module Eucalypt
  class Generate < Thor
    option :no, aliases: '-n', type: :array, default: [], desc: "Omit specified scaffold files"
    option :rest, aliases: '-r', type: :boolean, default: false,  desc: "Generate REST routes for the controller"
    desc "scaffold [NAME]", "Generates a scaffold"
    def scaffold(name)
      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        allowed = %i[
          helper h
          helper_spec hs
          model m
          model_spec ms
          controller c
          controller_spec cs
        ]
        opts = options[:no].map{|opt|opt.gsub(?-,?_).to_sym}
        legal = opts & allowed

        helper_spec = !(legal & %i[helper_spec hs]).present?
        model_spec = !(legal & %i[model_spec ms]).present?
        controller_spec = !(legal & %i[controller_spec cs]).present?

        if !(legal & %i[model m]).present? # Model
          model = Eucalypt::Generators::Model.new
          model.destination_root = directory
          model.generate(name: name, spec: model_spec)
        end

        if !(legal & %i[helper h]).present? # Helper
          helper = Eucalypt::Generators::Helper.new
          helper.destination_root = directory
          helper.generate(name: name, spec: helper_spec)
        end

        if !(legal & %i[controller c]).present? # Controller
          controller = Eucalypt::Generators::Controller.new
          controller.destination_root = directory
          controller.generate(
            name: name,
            spec: controller_spec,
            rest: options[:rest]
          )
        end
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end