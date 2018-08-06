require 'thor'
require 'eucalypt/helpers'
require 'eucalypt/helpers/app'
module Eucalypt
  class Generate < Thor
    include Eucalypt::Helpers

    option :no, aliases: '-n', type: :array, default: [], desc: "Omit specified scaffold files"
    option :rest, aliases: '-r', type: :boolean, default: false,  desc: "Generate REST routes for the controller"
    option :policy, aliases: '-p', type: :boolean, default: false, desc: "Generate a policy with the scaffold"
    desc "scaffold [NAME]", "Generates a scaffold".colorize(:grey)
    def scaffold(name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
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

        model = !(legal & %i[model m]).present?
        helper = !(legal & %i[helper h]).present?
        controller = !(legal & %i[controller c]).present?
        helper_spec = !(legal & %i[helper_spec hs]).present?
        model_spec = !(legal & %i[model_spec ms]).present?
        controller_spec = !(legal & %i[controller_spec cs]).present?

        if model
          model = Eucalypt::Generators::Model.new
          model.destination_root = directory
          model.generate(name: name, spec: model_spec)
        end

        if helper
          helper = Eucalypt::Generators::Helper.new
          helper.destination_root = directory
          helper.generate(name: name, spec: helper_spec)
        end

        if controller
          controller = Eucalypt::Generators::Controller.new
          controller.destination_root = directory
          policy = if options[:rest] && options[:policy]
            if model
              true
            else
              Out.error "Unable to create controller with policy routes without a model"
              Out.info "Creating REST-style controller instead..."
              false
            end
          else
            false
          end
          controller.generate(
            name: name,
            spec: controller_spec,
            rest: options[:rest],
            policy: policy
          )
        end

        if options[:policy]
          args = ['security', 'policy', 'generate', name]
          args << %w[-p edit add delete] if options[:rest]
          args.flatten!
          Eucalypt::CLI.start(args)
        end
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end